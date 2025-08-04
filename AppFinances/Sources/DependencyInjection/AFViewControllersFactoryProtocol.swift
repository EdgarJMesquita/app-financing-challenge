//
//  AFViewControllersFactoryProtocol.swift
//  AppFinances
//
//  Created by Edgar on 01/07/25.
//

import UIKit

protocol AFViewControllersFactoryProtocol: AnyObject {
    func makeSplashVC(flowDelegate: any SplashCoordinate) -> SplashVC
    func makeLoginVC(flowDelegate: any LoginCoordinate) -> LoginVC
    func makeHomeVC(flowDelegate: any HomeCoordinate) -> HomeVC
    func makeEntriesVC(monthYear: AFMonthYear, flowDelegate: PresentAddBudgetProtocol?) -> AFEntriesVC
    func makeAddEntryVC() -> AddEntryVC
    func makeAddBudgetVC() -> AddBudgetVC
}
