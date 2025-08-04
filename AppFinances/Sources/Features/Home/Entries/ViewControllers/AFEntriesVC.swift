//
//  EntriesVC.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import UIKit

class AFEntriesVC: UIViewController {
    let monthYear: AFMonthYear
    let contentView: AFEntriesView
    let viewModel: AFEntriesViewModel
    weak var flowDelegate: PresentAddBudgetProtocol?
    
    private var firstAppear: Bool = true
   
    init(monthYear: AFMonthYear, contentView: AFEntriesView, viewModel: AFEntriesViewModel, flowDelegate: PresentAddBudgetProtocol?){
        self.monthYear = monthYear
        self.contentView = contentView
        self.viewModel = viewModel
        self.flowDelegate = flowDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstAppear {
            firstAppear = false
            return
        }
        
        load()
    }
    
    func load(){
        viewModel.load(by: monthYear)
    }
    
    private func setup(){
        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView, safe: false)
        
        contentView.cardView.set(monthYear: monthYear)
        
        viewModel.delegate = self
        
        contentView.entryTableView.delegate = self
        contentView.entryTableView.dataSource = self
        
        handleSwipeDelete()
        
        setupNewBudgetAction()
    }
    
    private func configure(isLoading: Bool){
        if isLoading {
            contentView.entryTableView.alpha = 0
            contentView.cardView.set(state: .loading)
            return
        }
        
        guard
            let resume = viewModel.monthlyResume
        else {
            return
        }
     
        contentView.cardView.set(current: resume.used)
       
        if let percent = resume.percent {
            contentView.cardView.set(percent: percent)
        }
        
        if let available = resume.available {
            contentView.cardView.set(available: available)
        }
        
        if let budget = resume.budget {
            contentView.cardView.set(state: .result(budget: budget))
        } else {
            contentView.cardView.set(state: .empty)
        }
        
        contentView.entryTableView.reloadData()
        contentView.entryTableView.alpha = 1
    }
    
    private func setupNewBudgetAction(){
        let tapGesturer = UITapGestureRecognizer(target: self, action: #selector(didTapEditBudget))
        contentView.cardView.configImageView.addGestureRecognizer(tapGesturer)
        contentView.cardView.actionButton.addTarget(self, action: #selector(didTapNewBudget), for: .touchUpInside)
    }
    
    @objc
    private func didTapNewBudget(){
        flowDelegate?.presentAddBudgetVC(delegate: self, initialLimit: nil, initialMonthYear: monthYear)
    }
    
    @objc
    private func didTapEditBudget(){
        flowDelegate?.presentAddBudgetVC(
            delegate: self,
            initialLimit: viewModel.monthlyResume?.budget?.limit,
            initialMonthYear: monthYear
        )
    }
}

extension AFEntriesVC: AddBudgetDelegate {
    func didEditBudget(_ budget: AFBudget) {
        if
            budget.month == monthYear.month,
            budget.year == monthYear.year
        {
            load()
        }
    }
}

// MARK: EntriesViewModelDelegate
extension AFEntriesVC: AFEntriesViewModelDelegate {
    func viewModel(isLoading: Bool) {
        DispatchQueue.main.dispatchMainIfNeeded {
            self.configure(isLoading: isLoading)
        }
    }
    
    func viewModel(errorMessage: String) {
        let alertController = UIAlertController(title: "Atenção", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        DispatchQueue.main.dispatchMainIfNeeded {
            self.present(alertController, animated: true)
        }
    }
    
}

// MARK: EntriesTableViewDataSource
extension AFEntriesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.monthlyResume?.entries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let viewCell = tableView.dequeueReusableCell(withIdentifier: AFEntryTableViewCell.identifier, for: indexPath) as? AFEntryTableViewCell,
            let entries = viewModel.monthlyResume?.entries
        else {
            return UITableViewCell()
        }
        
        
        viewCell.configure(with: entries[indexPath.row], isLast: entries.endIndex - 1 == indexPath.row)
        
        viewCell.delegate = self
        
        return viewCell
    }
}

// MARK: EntriesTableViewDelegate
extension AFEntriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AFEntriesHeaderTableView(
            frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 42)
        )
        view.setTotal(viewModel.monthlyResume?.entries.count ?? 0)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        42
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle != .delete {
            return
        }
        
        guard
            let entries = viewModel.monthlyResume?.entries,
            let id = entries[indexPath.row].id
        else {
            return
        }
        
        viewModel.deleteEntry(id: id, index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        viewModel.load(by: monthYear, withLoading: false)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if
            let entries = viewModel.monthlyResume?.entries,
            entries.isEmpty
        {
            let view = AFEntriesFooterTableView(
                frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 64)
            )
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let entries = viewModel.monthlyResume?.entries {
            return entries.isEmpty ? 64 : 0
        }
        return 0
    }
    
}


// MARK: Enabling Swipe do Delete alongside UIPageViewController
extension AFEntriesVC: UIGestureRecognizerDelegate {
    func handleSwipeDelete() {
        if let pageController = parent as? UIPageViewController {
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: nil)
            gestureRecognizer.delaysTouchesBegan = true
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            
            contentView.entryTableView.addGestureRecognizer(gestureRecognizer)

            pageController.scrollView?.canCancelContentTouches = false
            pageController.scrollView?.panGestureRecognizer.require(toFail: gestureRecognizer)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }

        let translation = panGesture.translation(in: contentView.entryTableView)
        
        return abs(translation.x) > abs(translation.y)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.view == contentView.entryTableView
    }
}

extension AFEntriesVC: AFEntryTableViewCellDelegate {
    func didTapDelete(cell: AFEntryTableViewCell) {
        guard
            let id = cell.id,
            let index = viewModel.monthlyResume?.entries.firstIndex(where: { $0.id == id }),
            let entry = viewModel.monthlyResume?.entries[index]
        else {
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        
        
        
        let alertVC = UIAlertController(title: "Atenção", message: "Deseja mesmo excluir o registro \(entry.description)", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Voltar", style: .cancel))
        alertVC.addAction(UIAlertAction(
            title: "Excluir",
            style: .destructive,
            handler: { [weak self] _ in
                guard let self else {
                    return
                }
                viewModel.deleteEntry(id: id, index: index)
                contentView.entryTableView.deleteRows(at: [indexPath], with: .fade)
                viewModel.load(by: monthYear, withLoading: false)
            }
        ))
        
        present(alertVC,animated: true)
    }
}
