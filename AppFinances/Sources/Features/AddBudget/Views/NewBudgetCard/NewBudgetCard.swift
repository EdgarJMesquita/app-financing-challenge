//
//  NewBudgetCard.swift
//  AppFinances
//
//  Created by Edgar on 03/08/25.
//


import UIKit

class NewBudgetCard: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.title2Xs
        label.textColor = .afGray500
        label.text = "Novo orçamento"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .afGray200
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var valueInput: AFTextInput = {
        let textInput = AFTextInput(prefix: "R$")
        textInput.placeholder = "0,00"
        textInput.keyboardType = .decimalPad
        return textInput
    }()
    
    lazy var dateInput: AFTextInput = {
        let textInput = AFTextInput(icon: .afCalendar)
        textInput.placeholder = "00/0000"
        return textInput
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .yearAndMonth
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    lazy var actionButton: AFButton = {
        let button = AFButton(title: String(localized: "ADD"))
        return button
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
        
        backgroundColor = .afGray100
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.afGray300.cgColor
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHierarchy(){
        addSubview(titleLabel)
        addSubview(separatorView)
        addSubview(dateInput)
        addSubview(valueInput)
        addSubview(actionButton)
    }
    
    private func setupConstraints(){
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            dateInput.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            dateInput.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            dateInput.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -6),
            
            valueInput.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            valueInput.leadingAnchor.constraint(equalTo: centerXAnchor, constant: padding),
            valueInput.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            actionButton.topAnchor.constraint(equalTo: dateInput.bottomAnchor, constant: 16),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
        ])
    }
}


//#Preview {
//    NewBudgetCard(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
//}
