//
//  EntriesTableCustomHeaderView.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import UIKit

class AFBudgetsHeaderTableView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .afGray500
        label.text = "LANÇAMENTOS"
        label.font = AFTypography.title2Xs
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        backgroundColor = .afGray100
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupHierarchy(){
        addSubview(titleLabel)

    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
        ])
    }
}
