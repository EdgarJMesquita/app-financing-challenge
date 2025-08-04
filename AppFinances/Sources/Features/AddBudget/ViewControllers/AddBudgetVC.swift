//
//  AddEntryVC.swift
//  AppFinances
//
//  Created by Edgar on 21/07/25.
//

import UIKit

class AddBudgetVC: UIViewController {
    private let contentView: AddBudgetView
    
    private let formGroup: AFFormGroup<AddBudgetForm>
    private let viewModel: AddBudgetViewModel
    var initialLimit: Double?
    var initialMonthYear: AFMonthYear?
    
    weak var flowDelegate: AddBudgetFlowDelegate?
    weak var delegate: AddBudgetDelegate?
    
    
    init(contentView: AddBudgetView, viewModel: AddBudgetViewModel) {
        self.contentView = contentView
        self.viewModel = viewModel
        self.formGroup = AFFormGroup(model: AddBudgetForm())
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.getBudgets()
    }
    
    private func setup(){
        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView, safe: false)
        
        bindInputs()
        setupAction()
        setupDatePicker()
        setupBudgetDataSource()
        setInitialMonthValue()
        contentView.newBudgetCard.valueInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setInitialMonthValue(){
        if let value = initialLimit {
            contentView.newBudgetCard.valueInput.text = value
                .formatted(.currency(code: "BRL").locale(.current))
                .replacing(/[^0-9,.]/, with: "")
        }
        
        if let monthYear = initialMonthYear?.date {
            contentView.newBudgetCard.dateInput.text = monthYear.formatted(.dateTime.month(.twoDigits).year())
        }
    }
    
    private func bindInputs(){
        formGroup.bind(\.date, input: contentView.newBudgetCard.dateInput)
        formGroup.bind(\.value, input: contentView.newBudgetCard.valueInput)
    }
    
    private func setupAction(){
        contentView.goBackButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        contentView.newBudgetCard.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    private func setupBudgetDataSource(){
        contentView.budgetsTableView.dataSource = self
        contentView.budgetsTableView.delegate = self
    }
    
    @objc
    private func didTapActionButton(){
        guard
            formGroup.validate(),
            let formState = formGroup.getState()
        else {
            return
        }
            
        viewModel.createNewBudget(form: formState)
        
    }
    
    @objc
    private func didTapCloseButton(){
        flowDelegate?.dismiss()
    }
    
}

extension AddBudgetVC: AddBudgetViewModelDelegate {
    func viewModel(newBudget: AFBudget) {
        delegate?.didEditBudget(newBudget)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            contentView.newBudgetCard.dateInput.text = ""
            contentView.newBudgetCard.valueInput.text = ""
        }
    }
    
    func viewModel(isLoadingBudgets: Bool) {
        if !isLoadingBudgets {
            DispatchQueue.main.dispatchMainIfNeeded { [weak self] in
                self?.contentView.budgetsTableView.reloadData()
            }
        }
    }
    
    func viewModel(isLoadingCreatingNewBudget: Bool){
        DispatchQueue.main.dispatchMainIfNeeded { [weak self] in
            self?.contentView.newBudgetCard.actionButton.isLoading = isLoadingCreatingNewBudget
        }
    }
    
    func viewModel(errorTitle: String, errorMessage: String) {
        showAlertOnMainThread(title: errorTitle, message: errorMessage)
    }
}

// MARK: BudgetTableView
extension AddBudgetVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.budgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: AFBudgetTableViewCell.identifier, for: indexPath) as? AFBudgetTableViewCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.budgets[indexPath.row], isLast: viewModel.budgets.count - 1 == indexPath.row)
        cell.delegate = self
        return cell
    }
}

// MARK: BudgetTableView
extension AddBudgetVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AFBudgetsHeaderTableView(
            frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 42)
        )
     
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        42
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle != .delete {
            return
        }
        
        let budget = viewModel.budgets[indexPath.row]
        
        guard let id = budget.id else {
            return
        }
        
        viewModel.delete(id: id, index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        delegate?.didEditBudget(budget)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let budget = viewModel.budgets[indexPath.row]
        
        return !budget.isPast
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.budgets.isEmpty {
            let view = AFBudgetsFooterTableView(
                frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 64)
            )
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.budgets.isEmpty ? 64 : 0
    }
    
}


// MARK: Pickers setup
extension AddBudgetVC {
    
    private func setupDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(didSelectDate))

        toolbar.setItems([doneButton], animated: true)
        contentView.newBudgetCard.dateInput.inputView = contentView.newBudgetCard.datePicker
        contentView.newBudgetCard.dateInput.inputAccessoryView = toolbar
    }
    
    @objc
    private func didSelectDate(){
        contentView.newBudgetCard.dateInput.resignFirstResponder()
        contentView.newBudgetCard.dateInput.text = contentView.newBudgetCard.datePicker.date.formatted(.dateTime.month(.twoDigits).year())
    }
}

// MARK: TextField currency formatter
extension AddBudgetVC {
    @objc
    private func textFieldDidChange(_ textField: UITextField){
        textField.text = textField.text?.currencyInputFormatting()
    }
}

extension AddBudgetVC: AFBudgetTableViewCellDelegate {
    func didTapDelete(cell: AFBudgetTableViewCell) {
        guard
            let id = cell.id,
            let index = viewModel.budgets.firstIndex(where: { $0.id == id })
        else {
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        
        let budget = viewModel.budgets[index]
        
        
        let alertVC = UIAlertController(title: "Atenção", message: "Deseja mesmo excluir o orçamento \(budget.month)/\(budget.year)", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Voltar", style: .cancel))
        alertVC.addAction(UIAlertAction(
            title: "Excluir",
            style: .destructive,
            handler: { [weak self] _ in
                guard let self else {
                    return
                }
                viewModel.delete(id: id, index: index)
                contentView.budgetsTableView.deleteRows(at: [indexPath], with: .fade)
                delegate?.didEditBudget(viewModel.budgets[index])
            }
        ))
        
        present(alertVC,animated: true)
    }
}


protocol AddBudgetFlowDelegate: DismissProtocol {}


protocol AddBudgetDelegate: AnyObject {
    func didEditBudget(_ budget: AFBudget)
}
