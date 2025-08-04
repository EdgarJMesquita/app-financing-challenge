//
//  MonthSelectViewCell.swift
//  AppFinances
//
//  Created by Edgar on 04/07/25.
//

import Foundation
import UIKit

class MonthSelectViewCell: UICollectionViewCell {
    
    static let identifier = "MonthSelectViewCell"
    
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AFTypography.titleXs
        label.textColor = .afGray700
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .afMagenta
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with monthYear: AFMonthYear, isCentered: Bool){
        dateLabel.text = monthYear.formatted
        dateLabel.textColor = isCentered ? .afGray700 : .afGray400
        updateIndicator(isCentered)
    }
    
    private func setup(){
        contentView.addSubview(dateLabel)
        contentView.addSubview(indicatorView)
        
        
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            
            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant: 4),
            indicatorView.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor),
            indicatorView.widthAnchor.constraint(equalTo: dateLabel.widthAnchor),
            
        ])
    }
    
    private func updateIndicator(_ isCentered: Bool){
        indicatorView.alpha = isCentered ? 1 : 0
    }
    
}
