//
//  EntriesTableView.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import UIKit

class AFBudgetsTableView: UITableView {
    

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        
        allowsSelection = false
        
        translatesAutoresizingMaskIntoConstraints = false
        register(AFBudgetTableViewCell.self,forCellReuseIdentifier: AFBudgetTableViewCell.identifier)
        
        rowHeight = 67
        
        separatorColor = .afGray200
        separatorStyle = .singleLine
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        backgroundView = nil
        backgroundColor = .none
        
        layer.cornerRadius = 12
        layer.masksToBounds = true

    }
    
}

