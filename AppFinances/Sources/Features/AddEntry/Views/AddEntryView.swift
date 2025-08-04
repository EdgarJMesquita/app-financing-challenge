//
//  AddEntryView.swift
//  AppFinances
//
//  Created by Edgar on 20/07/25.
//

import UIKit

class AddEntryView: UIView {
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .afGray100
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.afMultiply, for: .normal)
        button.tintColor = .afGray500
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Novo lançamento".uppercased()
        label.font = AFTypography.titleXs
        label.textColor = .afGray700
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionTextInput: AFTextInput = {
        let textInput = AFTextInput()
        textInput.placeholder = "Título da transação"
        return textInput
    }()
    
    lazy var categoryInput: AFTextInput = {
        let textInput = AFTextInput(icon: .afTag)
        textInput.placeholder = "Categoria"
        return textInput
    }()
    
    lazy var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    lazy var valueInput: AFTextInput = {
        let textInput = AFTextInput(prefix: "R$")
        textInput.placeholder = "0,00"
        textInput.keyboardType = .decimalPad
        return textInput
    }()
    
    lazy var dateInput: AFTextInput = {
        let textInput = AFTextInput(icon: .afCalendar)
        textInput.placeholder = "00/00/0000"
        return textInput
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    lazy var selectTransactionType: AFSelectTransactionType = {
        let view = AFSelectTransactionType()
        return view
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .afGray300
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var actionButton: AFButton = {
        let button = AFButton(title: "Salvar")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        addBlurEffect()
    }
    
    private func setup(){
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(descriptionTextInput)
        contentView.addSubview(categoryInput)
        contentView.addSubview(valueInput)
        contentView.addSubview(dateInput)
        contentView.addSubview(selectTransactionType)
        contentView.addSubview(separator)
        contentView.addSubview(actionButton)
        addSubview(contentView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 480),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor,constant: -10),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 15),
            closeButton.widthAnchor.constraint(equalToConstant: 15),
            
            
            descriptionTextInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
            descriptionTextInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            descriptionTextInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32),
        
            categoryInput.topAnchor.constraint(equalTo: descriptionTextInput.bottomAnchor, constant: 16),
            categoryInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            categoryInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32),
        
            valueInput.topAnchor.constraint(equalTo: categoryInput.bottomAnchor, constant: 16),
            valueInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            valueInput.trailingAnchor.constraint(equalTo: contentView.centerXAnchor,constant: -8),

            dateInput.topAnchor.constraint(equalTo: valueInput.topAnchor),
            dateInput.leadingAnchor.constraint(equalTo: contentView.centerXAnchor,constant: 8),
            dateInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32),
            
            selectTransactionType.topAnchor.constraint(equalTo: dateInput.bottomAnchor, constant: 16),
            selectTransactionType.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            selectTransactionType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32),
            selectTransactionType.heightAnchor.constraint(equalToConstant: 44),
            
            separator.topAnchor.constraint(equalTo: selectTransactionType.bottomAnchor, constant: 28),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32),
            
            actionButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 28),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32),
        ])
    }
    
    private func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(effectView, at: 0)
    }
}
