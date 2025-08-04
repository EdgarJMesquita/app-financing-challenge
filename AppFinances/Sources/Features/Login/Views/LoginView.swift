//
//  LoginView.swift
//  App de Finanças
//
//  Created by Edgar on 21/06/25.
//

import UIKit

class LoginView: UIView {
    
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .afLoginLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.titleSm
        label.textColor = .afGray700
        label.text = String(localized: "LOGIN.WELCOME_MESSAGE")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.textSmRegular
        label.textColor = .afGray500
        label.text = String(localized: "LOGIN.SUBTITLE")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    lazy var usernameInput: AFTextInput = {
        let textInput = AFTextInput()
        textInput.placeholder = String(localized: "LOGIN.USERNAME")
        textInput.alpha = 0
        return textInput
    }()
    
    lazy var emailInput: AFTextInput = {
        let textInput = AFTextInput()
        textInput.validator = .email
        textInput.placeholder = "E-mail"
        textInput.alpha = 0
        return textInput
    }()
    
    lazy var passwordInput: AFTextInput = {
        let textInput = AFTextInput()
        textInput.enableSecureEntry = true
        textInput.placeholder = String(localized: "LOGIN.PASSWORD")
        textInput.alpha = 0
        return textInput
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .afGray300
        view.alpha = 0
        return view
    }()
    
    lazy var actionButton: AFButton = {
        let button = AFButton(title: String(localized: "LOGIN.ACTION_BUTTON"))
        button.alpha = 0
        return button
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        setupHierarchy()
        setupConstraints()
        backgroundColor = .afGray100
    }
    
    private func setupHierarchy(){
        addSubview(logoImageView)
        addSubview(welcomeLabel)
        addSubview(subtitleLabel)
        addSubview(usernameInput)
        addSubview(emailInput)
        addSubview(passwordInput)
        addSubview(separatorView)
        addSubview(actionButton)
    }
    
    private func setupConstraints(){
        let offset = UIScreen.main.bounds.width / 2
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -offset),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 12),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -12),
            logoImageView.heightAnchor.constraint(equalToConstant: 359),
            
            welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            subtitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            
            usernameInput.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            usernameInput.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            usernameInput.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            
            emailInput.topAnchor.constraint(equalTo: usernameInput.bottomAnchor, constant: 28),
            emailInput.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            emailInput.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            
            passwordInput.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 28),
            passwordInput.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            passwordInput.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 28),
            separatorView.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            actionButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor,constant: 28),
            actionButton.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
        ])
    }
  
    
}
