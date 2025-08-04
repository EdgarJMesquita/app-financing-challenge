//
//  EntriesTableCustomHeaderView.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import UIKit

class AFEntriesHeaderTableView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .afGray500
        label.text = "LANÇAMENTOS"
        label.font = AFTypography.title2Xs
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .afGray300
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .afGray500
        label.font = AFTypography.title2Xs
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setTotal(_ total: Int){
        totalLabel.text = "\(total)"
    }
    
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
//        afAddTopLeftRightBorder()
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupHierarchy(){
        addSubview(titleLabel)
        addSubview(totalContainer)
        addSubview(totalLabel)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            
            totalContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            totalContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalContainer.heightAnchor.constraint(equalToConstant: 18),
            totalContainer.widthAnchor.constraint(equalToConstant: 24),
            
            totalLabel.centerYAnchor.constraint(equalTo: totalContainer.centerYAnchor),
            totalLabel.centerXAnchor.constraint(equalTo: totalContainer.centerXAnchor),
        ])
    }
}
