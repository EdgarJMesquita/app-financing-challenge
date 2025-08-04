//
//  HomeView.swift
//  AppFinances
//
//  Created by Edgar on 27/06/25.
//

import UIKit

class HomeView: UIView {
    lazy var headerView: HomeHeaderView = {
        let headerView = HomeHeaderView()
        return headerView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var monthSelector: AFMonthSelector = {
        let collectionView = AFMonthSelector()
        return collectionView
    }()
    
    lazy var entriesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var actionButton: AFFloatingActionButton = {
        let button = AFFloatingActionButton()
        return button
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
    }
    
    private func setupHierarchy(){
        addSubview(headerView)
        addSubview(contentView)
        contentView.addSubview(monthSelector)
        contentView.addSubview(entriesContainerView)
        addSubview(actionButton)
    }
     
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40),
            
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
            monthSelector.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthSelector.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            monthSelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            monthSelector.heightAnchor.constraint(equalToConstant: 58),
            
            entriesContainerView.topAnchor.constraint(equalTo: monthSelector.bottomAnchor, constant: 16),
            entriesContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            entriesContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            entriesContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 12),
        ])
    }
    
}

