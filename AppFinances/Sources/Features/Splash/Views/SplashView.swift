//
//  SplashView.swift
//  App de Finanças
//
//  Created by Edgar on 20/06/25.
//

import UIKit

class SplashView: UIView {
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .afLogo
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        backgroundColor = .white
    }
    
    private func setupHierarchy(){
        addSubview(logoImageView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 160),
            logoImageView.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        afApplyGradient()
    }

}

