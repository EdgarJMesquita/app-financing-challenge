//
//  AFCoordinator.swift
//  App de Finanças
//
//  Created by Edgar on 20/06/25.
//
import UIKit

class AFCoordinator {
    
    private var navigationController: UINavigationController?
    private var viewControllersFactory: AFViewControllersFactoryProtocol
    
    
    init() {
        self.viewControllersFactory = AFViewControllersFactory()
    }
    
    func start() -> UINavigationController? {
        let viewController = viewControllersFactory.makeSplashVC(flowDelegate: self)
        navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
}

extension AFCoordinator: SplashCoordinate {
    
    func navigateToLogin() {
        let viewController = viewControllersFactory.makeLoginVC(flowDelegate: self)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(viewController, animated: true)
    }
    
}


extension AFCoordinator: LoginCoordinate {
    
    func navigateToHome() {
        DispatchQueue.main.dispatchMainIfNeeded {
            self.navigationController?.dismiss(animated: false)
            let viewController = self.viewControllersFactory.makeHomeVC(flowDelegate: self)
            self.navigationController?.setViewControllers([viewController], animated: false)
        }
    }
    
}



extension AFCoordinator: HomeCoordinate {
    func resetToSplash() {
        let viewController = viewControllersFactory.makeSplashVC(flowDelegate: self)
        self.navigationController?.setViewControllers([viewController], animated: false)
    }
    
 
    func presentAddBudgetVC(delegate: AddBudgetDelegate, initialLimit: Double?, initialMonthYear: AFMonthYear?) {
        let viewController = viewControllersFactory.makeAddBudgetVC()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = delegate
        viewController.flowDelegate = self
        viewController.initialLimit = initialLimit
        viewController.initialMonthYear = initialMonthYear
        navigationController?.present(viewController, animated: true)
    }
    
    func presentAddEntryVC(delegate: AddEntryDelegate) {
        let viewController = viewControllersFactory.makeAddEntryVC()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = delegate
        viewController.flowDelegate = self
        navigationController?.present(viewController, animated: true)
    }
    
}

extension AFCoordinator: AddEntryFlowDelegate {
    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
}

extension AFCoordinator: AddBudgetFlowDelegate { }
