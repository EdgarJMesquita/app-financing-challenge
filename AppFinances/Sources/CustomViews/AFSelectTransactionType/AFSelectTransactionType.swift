//
//  AFSelectTransactionType.swift
//  AppFinances
//
//  Created by Edgar on 22/07/25.
//

import UIKit


class AFSelectTransactionType: UIView {
    var validator: AFFieldValidator<AFEntry.AFType> = .nonNil
    
    private(set) var transactionType: AFEntry.AFType? = nil {
        didSet {
            didSetTransactionType()
        }
    }
    
    private lazy var incomeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.afCaretUpFill, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        button.setTitle("Entrada", for: .normal)
        button.titleLabel?.font = AFTypography.buttonSm
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        
        setUnselectedColor(.afGreen, on: button)
        return button
    }()
    
    private lazy var expenseButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.afCaretDownFill, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        button.setTitle("Saída", for: .normal)
        button.titleLabel?.font = AFTypography.buttonSm
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        
        setUnselectedColor(.afRed, on: button)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .afRed
        label.font = AFTypography.titleSm
        label.text = "Escolha o tipo"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        setupHierarchy()
        setupConstraints()
        setupActions()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHierarchy(){
        addSubview(incomeButton)
        addSubview(expenseButton)
        addSubview(errorLabel)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            incomeButton.topAnchor.constraint(equalTo: topAnchor),
            incomeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            incomeButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -6),
            incomeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            expenseButton.topAnchor.constraint(equalTo: topAnchor),
            expenseButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 6),
            expenseButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            expenseButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setSelectedColor(_ color: UIColor, on button: UIButton){
        button.setTitleColor(.afGray100, for: .normal)
        button.tintColor = .afGray100
        button.imageView?.tintColor = .afGray100
        button.backgroundColor = color
        button.layer.borderColor = color.cgColor
    }
    
    private func setUnselectedColor(_ color: UIColor, on button: UIButton){
        button.setTitleColor(color, for: .normal)
        button.tintColor = color
        button.imageView?.tintColor = color
        button.backgroundColor = color.withAlphaComponent(0.05)
        button.layer.borderColor = color.cgColor
    }
    
    private func didSetTransactionType(){
        switch transactionType {
        case .income:
            setSelectedColor(.afGreen, on: incomeButton)
            setUnselectedColor(.afRed, on: expenseButton)
        case .expense:
            setUnselectedColor(.afGreen, on: incomeButton)
            setSelectedColor(.afRed, on: expenseButton)
        case nil:
            setUnselectedColor(.afGreen, on: incomeButton)
            setUnselectedColor(.afRed, on: expenseButton)
        }
    }
    
    private func setupActions(){
        incomeButton.addTarget(self, action: #selector(didTapIncomeButton), for: .touchUpInside)
        expenseButton.addTarget(self, action: #selector(didTapExpenseButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapIncomeButton(){
        transactionType = .income
    }
    
    @objc
    private func didTapExpenseButton(){
        transactionType = .expense
    }
    
    
}

extension AFSelectTransactionType: AFBindableFormInput {
    func getValue() -> AFEntry.AFType? {
        return transactionType
    }

    typealias Value = AFEntry.AFType
    
    func didValidate(isValid: Bool) {
        print(isValid)
        errorLabel.alpha = isValid ? 0 : 1
    }
    
}
