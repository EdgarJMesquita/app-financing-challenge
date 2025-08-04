//
//  PresentAddEntryProtocol.swift
//  AppFinances
//
//  Created by Edgar on 27/07/25.
//


protocol PresentAddBudgetProtocol: AnyObject {
    func presentAddBudgetVC(delegate: AddBudgetDelegate, initialLimit: Double?, initialMonthYear: AFMonthYear?)
}
