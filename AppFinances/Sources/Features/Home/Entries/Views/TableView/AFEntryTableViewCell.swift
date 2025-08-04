//
//  EntryTableViewCell.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import UIKit

class AFEntryTableViewCell: UITableViewCell {
    static let identifier = "EntryTableViewCell"
    weak var delegate: AFEntryTableViewCellDelegate?
    
    private(set) var id: String?
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .afGray200
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.afGray300.cgColor
        return view
    }()
    
    
    private lazy var entryTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .afMagenta
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .afGray700
        label.font = AFTypography.textSmBold
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
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
    
    private lazy var transactionType: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    
    func configure(with entry: AFEntry, isLast: Bool = false) {
        id = entry.id
        
        descriptionLabel.text = entry.description
        dateLabel.text = entry.dueAt.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year(.twoDigits))
        valueLabel.text = entry.value
            .formatted(.currency(code: "BRL").locale(Locale.current))
            .replacingOccurrences(of: "R$", with: "")
 
        entryTypeImageView.image = entry.getImage()
        
        switch entry.type {
        case .income:
            transactionType.image = .afCaretUpFill
            transactionType.tintColor = .afGreen
        case .expense:
            transactionType.image = .afCaretDownFill
            transactionType.tintColor = .afRed
        }
        
        if isLast {
            contentView.layer.cornerRadius = 12
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            contentView.layer.cornerRadius = 0
        }
    }
    
    private func setup(){
        setupHierarchy()
        setupConstraints()
        backgroundColor = .clear
        contentView.backgroundColor = .afGray100
        
        deleteImageView.isUserInteractionEnabled = true
        deleteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDelete)))
    }
    
    @objc
    private func didTapDelete(){
        delegate?.didTapDelete(cell: self)
    }
    
    private func setupHierarchy(){
        contentView.addSubview(imageContainer)
        contentView.addSubview(entryTypeImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(currencySignLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(transactionType)
        contentView.addSubview(deleteImageView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            imageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageContainer.heightAnchor.constraint(equalToConstant: 32),
            imageContainer.widthAnchor.constraint(equalToConstant: 32),
            
            entryTypeImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            entryTypeImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            entryTypeImageView.heightAnchor.constraint(equalToConstant: 20),
            entryTypeImageView.widthAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor,constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: currencySignLabel.leadingAnchor, constant: -20),
            
            dateLabel.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            currencySignLabel.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor),
            currencySignLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -2),
            
            valueLabel.trailingAnchor.constraint(equalTo: transactionType.leadingAnchor, constant: -6),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            transactionType.trailingAnchor.constraint(equalTo: deleteImageView.leadingAnchor, constant:  -12),
            transactionType.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            transactionType.widthAnchor.constraint(equalToConstant: 12),
            transactionType.heightAnchor.constraint(equalToConstant: 12),
            
            deleteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteImageView.heightAnchor.constraint(equalToConstant: 16),
            deleteImageView.widthAnchor.constraint(equalToConstant: 16),
        ])
    }
}

protocol AFEntryTableViewCellDelegate: AnyObject {
    func didTapDelete(cell: AFEntryTableViewCell)
}
