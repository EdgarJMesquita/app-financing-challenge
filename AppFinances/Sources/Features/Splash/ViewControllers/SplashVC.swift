//
//  SplashVC.swift
//  AppFinances
//
//  Created by Edgar on 01/07/25.
//

import UIKit

class SplashVC: UIViewController {
    
    private let contentView: SplashView
    private weak var flowDelegate: SplashCoordinate?

    
    init(contentView: SplashView,  flowDelegate: SplashCoordinate? = nil) {
        self.contentView = contentView
        self.flowDelegate = flowDelegate
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView, safe: false)
    
   
        Task {
            await animateSplash()
            flowDelegate?.navigateToLogin()
        }
    }
    
    func animateSplash() async {
        return await withCheckedContinuation { (continuation:CheckedContinuation<Void, Never>) in
            UIView.animateKeyframes(withDuration: 2, delay: 0) { [weak self] in
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) { [weak self] in
                    self?.contentView.logoImageView.alpha = 1
                }
      
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) { [weak self] in
                    let offset = UIScreen.main.bounds.width / 2
                    let transform = CGAffineTransform(translationX: 0, y: -offset)
                    self?.contentView.logoImageView.transform = transform
                }

            } completion: { _ in
                continuation.resume()
            }
        }
        
    }
    
}

protocol SplashCoordinate: AnyObject {
    func navigateToLogin()
}
