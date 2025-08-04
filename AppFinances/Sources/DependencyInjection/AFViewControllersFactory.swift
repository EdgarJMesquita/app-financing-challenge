//
//  AFViewControllersFactory.swift
//  AppFinances
//
//  Created by Edgar on 01/07/25.
//

import UIKit

class AFViewControllersFactory: AFViewControllersFactoryProtocol {
    
    func makeSplashVC(flowDelegate: any SplashCoordinate) -> SplashVC {
        let contentView = SplashView()
        let viewController = SplashVC(
            contentView: contentView,
            flowDelegate: flowDelegate
        )
        
        return viewController
    }
    
    func makeLoginVC(flowDelegate: any LoginCoordinate) -> LoginVC {
        let contentView = LoginView()
        let viewModel = LoginViewModel(service: FirebaseAuthService())
        let viewController = LoginVC(
            contentView: contentView,
            viewModel: viewModel,
            flowDelegate: flowDelegate
        )
        
        return viewController
    }
    
    func makeHomeVC(flowDelegate: any HomeCoordinate) -> HomeVC {
        let contentView = HomeView()
        let viewModel = HomeViewModel(service: FirebaseAuthService())
        let viewController = HomeVC(
            contentView: contentView,
            viewModel: viewModel,
            flowDelegate: flowDelegate
        )
        
        return viewController
    }
    
    func makeEntriesVC(monthYear: AFMonthYear, flowDelegate: PresentAddBudgetProtocol?) -> AFEntriesVC {
        let contentView = AFEntriesView()
        let viewModel = AFEntriesViewModel(entriesService: FirebaseEntryService(), budgetsService: FirebaseBudgetService())
        let viewController = AFEntriesVC(
            monthYear: monthYear,
            contentView: contentView,
            viewModel: viewModel,
            flowDelegate: flowDelegate
        )
        
        return viewController
    }
    
    func makeAddEntryVC() -> AddEntryVC {
        let contentView = AddEntryView()
        let viewModel = AddEntryViewModel(service: FirebaseEntryService())
        let viewController = AddEntryVC(contentView: contentView, viewModel: viewModel)
        
        return viewController
    }
    
    func makeAddBudgetVC() -> AddBudgetVC {
        let contentView = AddBudgetView()
        let viewModel = AddBudgetViewModel(service: FirebaseBudgetService())
        let viewController = AddBudgetVC(contentView: contentView, viewModel: viewModel)
        
        return viewController
    }
    
    
}
