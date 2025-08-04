//
//  HomerHeaderView.swift
//  AppFinances
//
//  Created by Edgar on 30/06/25.
//

import UIKit

class HomeHeaderView: UIView {
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.afGray700.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.titleSm
        label.textColor = .afGray700
        label.text = "Olá, "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.font = AFTypography.titleSm
        textField.textColor = .afGray700
        textField.placeholder = "Seu nome"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AFTypography.textSmRegular
        label.textColor = .afGray500
        label.text = "Vamos organizar suas finanças?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var logoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .afLogout
        imageView.tintColor = UIColor.afGray500
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHierarchy(){
        addSubview(avatarImageView)
        addSubview(greetingLabel)
        addSubview(usernameTextField)
        addSubview(subtitleLabel)
        addSubview(logoutImageView)
    }
    
    private func setupConstraints(){
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            
            greetingLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            greetingLabel.trailingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            
            usernameTextField.centerYAnchor.constraint(equalTo: greetingLabel.centerYAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: greetingLabel.trailingAnchor, constant: 2),
            usernameTextField.trailingAnchor.constraint(equalTo: logoutImageView.leadingAnchor, constant: -12),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            subtitleLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            subtitleLabel.trailingAnchor.constraint(equalTo: logoutImageView.leadingAnchor, constant: 12),
            
            logoutImageView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            logoutImageView.heightAnchor.constraint(equalToConstant: 20),
            logoutImageView.widthAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
}
