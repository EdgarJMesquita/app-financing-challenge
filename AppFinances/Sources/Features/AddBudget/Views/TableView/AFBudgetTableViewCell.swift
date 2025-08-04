//
//  EntryTableViewCell.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import UIKit

class AFBudgetTableViewCell: UITableViewCell {
    static let identifier = "AFBudgetTableViewCell"
    
    private(set) var id: String?
    
    weak var delegate: AFBudgetTableViewCellDelegate?
    
    private lazy var calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .afGray700
        imageView.image = .afCalendar
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .afGray700
        label.font = AFTypography.textSmBold
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .afGray500
        label.font = AFTypography.textXs
        return label
    }()
    
    private lazy var currencySignLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .afGray700
        label.font = AFTypography.textXs
        label.text = "R$"
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .afGray700
        label.font = AFTypography.titleMd
        label.sizeToFit()
        return label
    }()

    private lazy var deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .afTrash
        imageView.tintColor = .afMagenta
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with budget: AFBudget, isLast: Bool = false) {
        id = budget.id
        
        var dateComponents = Calendar.current.dateComponents([.month, .year], from: .now)
        dateComponents.month = budget.month
        dateComponents.year = budget.year
        
        if let date = Calendar.current.date(from: dateComponents) {
            monthLabel.text = date.formatted(.dateTime.month(.wide)).capitalized
            yearLabel.text = date.formatted(.dateTime.year(.defaultDigits))
        }
        
     
        valueLabel.text = budget.limit
            .formatted(.currency(code: "BRL").locale(Locale.current))
            .replacingOccurrences(of: "R$", with: "")
        
        if isLast {
            contentView.layer.cornerRadius = 12
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            contentView.layer.cornerRadius = 0
        }
        
        if budget.isPast {
            deleteImageView.isHidden = true
            contentView.alpha = 0.5
        } else {
            deleteImageView.isHidden = false
            contentView.alpha = 1
        }
        
    }
    
    @objc
    private func didTapDelete(){
        delegate?.didTapDelete(cell: self)
    }
    
    private func setup(){
        setupHierarchy()
        setupConstraints()
        backgroundColor = .clear
        contentView.backgroundColor = .afGray100
        
        deleteImageView.isUserInteractionEnabled = true
        deleteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDelete)))
   
    }
    
    private func setupHierarchy(){
        contentView.addSubview(calendarImageView)
        contentView.addSubview(monthLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(currencySignLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(deleteImageView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            
            calendarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            calendarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calendarImageView.heightAnchor.constraint(equalToConstant: 20),
            calendarImageView.widthAnchor.constraint(equalToConstant: 20),
            
            monthLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            monthLabel.leadingAnchor.constraint(equalTo: calendarImageView.trailingAnchor,constant: 12),
            
            yearLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor, constant: 6),
            yearLabel.trailingAnchor.constraint(equalTo: currencySignLabel.trailingAnchor),
            
            currencySignLabel.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor),
            currencySignLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -2),
            
            valueLabel.trailingAnchor.constraint(equalTo: deleteImageView.leadingAnchor, constant: -12),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            deleteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteImageView.heightAnchor.constraint(equalToConstant: 16),
            deleteImageView.widthAnchor.constraint(equalToConstant: 16),
        ])
    }
}

protocol AFBudgetTableViewCellDelegate: AnyObject {
    func didTapDelete(cell: AFBudgetTableViewCell)
}
