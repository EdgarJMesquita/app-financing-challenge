//
//  UIViewController+Ext.swift
//  App de Finanças
//
//  Created by Edgar on 20/06/25.
//

import UIKit

extension UIViewController {
    func setupContentViewToBounds(contentView: UIView, safe: Bool? = true) {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        if safe == true {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        }

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showAlertOnMainThread(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        DispatchQueue.main.dispatchMainIfNeeded { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}
