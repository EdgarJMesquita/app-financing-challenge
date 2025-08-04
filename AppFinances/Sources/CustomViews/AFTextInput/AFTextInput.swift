//
//  AFTextInput.swift
//  App de Finanças
//
//  Created by Edgar on 21/06/25.
//

import UIKit
import Combine



class AFTextInput: UITextField {
    
    
    enum AFTextInputState {
        case normal
        case focused
        case error
    }
    
    var validator: AFFieldValidator<String> = .text
    
    @Published private(set) var inputState: AFTextInputState = .normal {
        didSet {
            updateByState()
        }
    }
    
    var icon: UIImage? {
        get { iconImageView.image }
        set {
            iconImageView.image = newValue
            refreshLeftView()
            updateByState()
        }
    }
    
    var prefix: String? {
        get { prefixLabel.text }
        set {
            prefixLabel.text = newValue
            refreshLeftView()
            updateByState()
        }
    }
    
    var enableSecureEntry: Bool = false {
        didSet {
            enableSecureEntry ? setupSecureTextIcon() : removeSecureTextIcon()
        }
    }
    
    
    private lazy var prefixView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var prefixLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.titleMd
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var suffixView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secureTextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    init(icon: UIImage?, prefix: String?) {
        super.init(frame: .zero)
        self.iconImageView.image = icon
        self.prefixLabel.text = prefix
        setup()
        delegate = self
    }
    
    convenience init(icon: UIImage) {
        self.init(icon: icon, prefix: nil)
    }
    
    convenience init(prefix: String) {
        self.init(icon: nil, prefix: prefix)
    }
    
    convenience init(){
        self.init(icon: nil, prefix: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        backgroundColor = .afGray200
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        setupBorder()
        refreshLeftView()
        updateByState()
    }
    
    private func setupBorder(){
        layer.borderWidth = 1
        layer.borderColor = UIColor.afGray300.cgColor
    }
    
    private func refreshLeftView(){
        leftViewMode = .always
        
        prefixView.subviews.forEach { $0.removeFromSuperview() }
        
        var prefixViewWidth: CGFloat = 24
        
        if iconImageView.image != nil {
            prefixView.addSubview(iconImageView)
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: prefixView.leadingAnchor, constant: 14),
                iconImageView.centerYAnchor.constraint(equalTo: prefixView.centerYAnchor),
                iconImageView.heightAnchor.constraint(equalToConstant: 16),
                iconImageView.widthAnchor.constraint(equalToConstant: 16),
            ])
            prefixViewWidth += 16
        }
        
        if prefixLabel.text != nil && iconImageView.image != nil {
            prefixView.addSubview(prefixLabel)
            prefixLabel.setContentHuggingPriority(.required, for: .horizontal)
      
            NSLayoutConstraint.activate([
                prefixLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                prefixLabel.centerYAnchor.constraint(equalTo: prefixView.centerYAnchor),
                iconImageView.heightAnchor.constraint(equalToConstant: 16),
                iconImageView.widthAnchor.constraint(equalToConstant: 16),
            ])
            prefixViewWidth += 30
        }
        
        if prefixLabel.text != nil && iconImageView.image == nil {
            prefixView.addSubview(prefixLabel)
            prefixLabel.setContentHuggingPriority(.required, for: .horizontal)
            NSLayoutConstraint.activate([
                prefixLabel.leadingAnchor.constraint(equalTo: prefixView.leadingAnchor, constant: 14),
                prefixLabel.centerYAnchor.constraint(equalTo: prefixView.centerYAnchor),
                prefixLabel.heightAnchor.constraint(equalToConstant: 16),
            ])
            
            prefixViewWidth += 16
        }
        
      
        NSLayoutConstraint.activate([
            prefixView.widthAnchor.constraint(equalToConstant: prefixViewWidth),
            prefixView.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        leftView = prefixView
    }
    
    private func updateByState(){
        switch inputState {
        case .normal:
            setBorderColor(with: .afGray300)
            setIconAndPrefixColor(with: .afGray600)
        case .focused:
            setBorderColor(with: .afMagenta)
            setIconAndPrefixColor(with: .afMagenta)
        case .error:
            setBorderColor(with: .afRed)
            setIconAndPrefixColor(with: .afRed)
        }
    }
    
    private func setBorderColor(with color: UIColor){
        layer.borderColor = color.cgColor
    }
    
    private func setIconAndPrefixColor(with color: UIColor){
        iconImageView.tintColor = color
        prefixLabel.textColor = color
    }
    
    private func setupSecureTextIcon(){
        suffixView.addSubview(secureTextImageView)
        
        rightView = suffixView
        rightViewMode = .always
        
        isSecureTextEntry = true
        
        secureTextImageView.image = .afEyeClosed
        
        secureTextImageView.tintColor = .afGray700
        
        NSLayoutConstraint.activate([
            suffixView.widthAnchor.constraint(equalToConstant: 48),
            suffixView.heightAnchor.constraint(equalToConstant: 48),
            secureTextImageView.centerYAnchor.constraint(equalTo: suffixView.centerYAnchor),
            secureTextImageView.centerXAnchor.constraint(equalTo: suffixView.centerXAnchor),
            secureTextImageView.widthAnchor.constraint(equalToConstant: 20),
            secureTextImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        secureTextImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapSecureTextIcon))
        )
    }
    
    private func removeSecureTextIcon(){
        suffixView.subviews.forEach { $0.removeFromSuperview() }
        rightView = nil
    }
    
    @objc
    private func didTapSecureTextIcon(){
        isSecureTextEntry.toggle()
        secureTextImageView.image = isSecureTextEntry ? .afEyeClosed : .afEye
    }
    
    
}

extension AFTextInput: AFBindableFormInput {

    
    func didValidate(isValid: Bool) {
        inputState = isValid ? .normal : .error
    }
  
    func getValue() -> String? {
        return text
    }
    
    
}

extension AFTextInput: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if inputState == .error {
            return
        }
        inputState = .focused
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputState = .normal
    }
    
    
}
