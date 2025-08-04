//
//  AFButton.swift
//  App de Finanças
//
//  Created by Edgar on 23/06/25.
//

import UIKit

class AFButton: UIButton {
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private var title = ""
    
    var isLoading = false {
        didSet {
            updateLoading()
        }
    }
    
    var isOutlined: Bool = false {
        didSet {
            setupOutlined()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupOutlined()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, isOutlined: Bool = false){
        self.init(frame: .zero)
        self.isOutlined = isOutlined
        self.title = title
        setTitle(title, for: .normal)
        setupOutlined()
    }
    
    private func setup(){
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        titleLabel?.font = AFTypography.buttonMd
  
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        setupLoadingView()
    }
    
    private func setupLoadingView(){
        addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func updateLoading(){
        isEnabled = !isLoading
        
        if isLoading {
            
            activityIndicatorView.startAnimating()
            setTitle(nil, for: .normal)
            return
        }
        
        activityIndicatorView.stopAnimating()
        setTitle(self.title, for: .normal)
    }
    
    private func setupOutlined(){
        if isOutlined {
            backgroundColor = .afMagenta.withAlphaComponent(0.05)
            setTitleColor(.afMagenta, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.afMagenta.cgColor
            return
        } else {
            layer.borderWidth = 0
            layer.borderColor = nil
            setTitleColor(.afGray100, for: .normal)
            backgroundColor = .afMagenta
        }
    }
}
