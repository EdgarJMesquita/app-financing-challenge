//
//  AFFloatingActionButton.swift
//  AppFinances
//
//  Created by Edgar on 20/07/25.
//

import UIKit


class AFFloatingActionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        translatesAutoresizingMaskIntoConstraints = false
        
        setImage(.afPlus, for: .normal)
        tintColor = .white
        backgroundColor = .afGray700
        
        layer.cornerRadius = 24

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),
            widthAnchor.constraint(equalToConstant: 48),
        ])
    }
}
