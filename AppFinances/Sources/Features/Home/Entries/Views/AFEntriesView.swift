//
//  EntriesView.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import UIKit

class AFEntriesView: UIView {
    
    lazy var cardView: AFCardView = {
        let view = AFCardView()
        return view
    }()
    
    lazy var entryTableView: AFEntriesTableView = {
        let tableView = AFEntriesTableView()
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
        addSubview(cardView)
        addSubview(entryTableView)
    }
     
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalToConstant: 232),
            
            entryTableView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20),
            entryTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            entryTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            entryTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
