//
//  AddEntryView.swift
//  AppFinances
//
//  Created by Edgar on 20/07/25.
//

import UIKit

class AddBudgetView: UIView {
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .afGray100
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var goBackButton: UIButton = {
        let button = UIButton()
        button.setImage(.afChevronLeft, for: .normal)
        button.tintColor = .afGray500
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "ADDBUDGET.HEADER.TITLE")
        label.font = AFTypography.titleSm
        label.textColor = .afGray700
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "ADDBUDGET.HEADER.SUBTITLE")
        label.font = AFTypography.textSmRegular
        label.textColor = .afGray500
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var newBudgetCard: NewBudgetCard = {
        let view = NewBudgetCard()
        return view
    }()
    
    lazy var budgetsTableView: AFBudgetsTableView = {
        let tableView = AFBudgetsTableView()
        return tableView
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
        backgroundColor = .afGray200
    }
    
    private func setupHierarchy(){
        headerView.addSubview(goBackButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(goBackButton)
        addSubview(headerView)
        
        addSubview(newBudgetCard)
        addSubview(budgetsTableView)
    }
    
    private func setupConstraints(){
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 150),
            
            goBackButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 31),
            goBackButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            goBackButton.heightAnchor.constraint(equalToConstant: 24),
            goBackButton.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor,constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: goBackButton.trailingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: goBackButton.trailingAnchor, constant: 16),
            
            newBudgetCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            newBudgetCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            newBudgetCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            newBudgetCard.heightAnchor.constraint(equalToConstant: 200),
            
            budgetsTableView.topAnchor.constraint(equalTo: newBudgetCard.bottomAnchor, constant: padding),
            budgetsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            budgetsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            budgetsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
    
}
