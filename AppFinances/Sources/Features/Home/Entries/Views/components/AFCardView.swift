//
//  CardView.swift
//  AppFinances
//
//  Created by Edgar on 08/07/25.
//

import UIKit

class AFCardView: UIView {
    
    private var trackerProgress: NSLayoutConstraint?
    
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.titleSm
        label.textColor = .afGray100
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.titleSm
        label.textColor = .afGray400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var configImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .afSettingsFill
        imageView.tintColor = .afGray100
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .afSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var availableBudgetLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "HOME.CARD.BUDGET.LABEL")
        label.font = AFTypography.titleSm
        label.textColor = .afGray400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var actionButton: AFButton = {
        let button = AFButton(title: String(localized: "HOME.CARD.ACTION.BUTTON.LABEL"), isOutlined: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .afMagenta
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var availableBudgetValueLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.titleLg
        label.textColor = .afGray100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentBudgeLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "HOME.CARD.USED.LABEL")
        label.font = AFTypography.textXs
        label.textColor = .afGray400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentBudgeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "R$ 0,00"
        label.font = AFTypography.textSmRegular
        label.textColor = .afGray100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var maxBudgeLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "HOME.CARD.MAX.LABEL")
        label.font = AFTypography.textXs
        label.textColor = .afGray400
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var maxBudgeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "R$ 0,00"
        label.font = AFTypography.textSmRegular
        label.textColor = .afGray100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var progressContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .afGray600
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private lazy var progressTrackerView: UIView = {
        let view = UIView()
        view.backgroundColor = .afMagenta
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
//        setLoadingState() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        afApplyGradient()
    }
    
    private func setup(){
        setupHierarchy()
        setupConstraints()
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHierarchy(){
        addSubview(monthLabel)
        addSubview(yearLabel)
        addSubview(configImageView)
        addSubview(separatorView)
        addSubview(availableBudgetLabel)
        addSubview(availableBudgetValueLabel)
        addSubview(actionButton)
        addSubview(activityIndicatorView)
        addSubview(currentBudgeLabel)
        addSubview(currentBudgeValueLabel)
        addSubview(maxBudgeLabel)
        addSubview(maxBudgeValueLabel)
        addSubview(progressContainerView)
        addSubview(progressTrackerView)
    }
    
    private func setupConstraints(){
        let padding: CGFloat = 24
        
        let trackerProgress = progressTrackerView.widthAnchor.constraint(equalToConstant: 0)
        self.trackerProgress = trackerProgress
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            yearLabel.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor, constant: 8),
            
            configImageView.topAnchor.constraint(equalTo: monthLabel.topAnchor),
            configImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            configImageView.heightAnchor.constraint(equalToConstant: 20),
            configImageView.widthAnchor.constraint(equalToConstant: 20),
            
            separatorView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 13),
            separatorView.leadingAnchor.constraint(equalTo: monthLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: configImageView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            availableBudgetLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 13),
            availableBudgetLabel.leadingAnchor.constraint(equalTo: monthLabel.leadingAnchor),
            
            availableBudgetValueLabel.topAnchor.constraint(equalTo: availableBudgetLabel.bottomAnchor, constant: 12),
            availableBudgetValueLabel.leadingAnchor.constraint(equalTo: monthLabel.leadingAnchor),
            availableBudgetValueLabel.trailingAnchor.constraint(equalTo: configImageView.trailingAnchor),
            
            actionButton.topAnchor.constraint(equalTo: availableBudgetLabel.bottomAnchor, constant: 12),
            actionButton.leadingAnchor.constraint(equalTo: monthLabel.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: configImageView.trailingAnchor),
            
            activityIndicatorView.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
            
            currentBudgeLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            currentBudgeLabel.leadingAnchor.constraint(equalTo: monthLabel.leadingAnchor),
            
            currentBudgeValueLabel.topAnchor.constraint(equalTo: currentBudgeLabel.bottomAnchor, constant: 8),
            currentBudgeValueLabel.leadingAnchor.constraint(equalTo: monthLabel.leadingAnchor),
            
            maxBudgeLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            maxBudgeLabel.trailingAnchor.constraint(equalTo: configImageView.trailingAnchor),
            
            maxBudgeValueLabel.topAnchor.constraint(equalTo: currentBudgeLabel.bottomAnchor, constant: 8),
            maxBudgeValueLabel.trailingAnchor.constraint(equalTo: configImageView.trailingAnchor),
            
            progressContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressContainerView.heightAnchor.constraint(equalToConstant: 8),
            
            progressTrackerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressTrackerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressTrackerView.heightAnchor.constraint(equalToConstant: 8),
            trackerProgress
        ])
    }
    
    func set(monthYear: AFMonthYear){
        monthLabel.text = monthYear.formattedMonth
        yearLabel.text = "/ \(monthYear.year)"
    }

    func set(state: SearchState){
        switch state {
        case .loading:
            setLoadingState()
        case .empty:
            setEmptyState()
        case .result(budget: let budget):
            setBudgetState(budget: budget)
        case .error(error: let error):
            print(error.localizedDescription)
        }
    }
    
    private func setLoadingState(){
        actionButton.isHidden = true
        availableBudgetValueLabel.isHidden = true
        
        availableBudgetValueLabel.text = ""
        currentBudgeValueLabel.text = 0.formatted(.currency(code: "BRL").locale(.current))
        maxBudgeValueLabel.text = "∞"
        
        activityIndicatorView.startAnimating()
    }
    
    private func setEmptyState(){
        trackerProgress?.constant = 0
        progressTrackerView.layoutIfNeeded()
        
        availableBudgetValueLabel.text = ""
        currentBudgeValueLabel.text = 0.formatted(.currency(code: "BRL").locale(.current))
        maxBudgeValueLabel.text = "∞"
        
        actionButton.isHidden = false
        
        availableBudgetValueLabel.isHidden = true
        progressContainerView.isHidden = true
        progressTrackerView.isHidden = true
        
        activityIndicatorView.stopAnimating()
    }
    
    private func setBudgetState(budget: AFBudget){
        activityIndicatorView.stopAnimating()
        
        maxBudgeValueLabel.text = budget.limit.formatted(.currency(code: "BRL").locale(.current))
        
        actionButton.isHidden = true
        
        availableBudgetValueLabel.isHidden = false
        progressContainerView.isHidden = false
        progressTrackerView.isHidden = false
  
    }
    
    func set(available: Double){
        availableBudgetValueLabel.text = available.formatted(.currency(code: "BRL").locale(.current))
    }
    
    func set(current: Double){
        currentBudgeValueLabel.text = current.formatted(.currency(code: "BRL").locale(.current))
    }
    
    func set(percent: Double){
        progressTrackerView.alpha = 1
        progressContainerView.alpha = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){ [weak self] in
            guard let self else {
                return
            }
            trackerProgress?.constant = bounds.width * percent
            UIView.animate(withDuration: 1) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }

}

