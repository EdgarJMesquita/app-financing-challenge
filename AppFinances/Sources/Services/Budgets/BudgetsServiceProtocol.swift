//
//  EntriesServiceProtocol.swift
//  AppFinances
//
//  Created by Edgar on 18/07/25.
//

protocol BudgetsServiceProtocol: AnyObject {
    
    func getBudget(by monthYear: AFMonthYear) async throws -> AFBudget?
    
    func getBudgets() async throws -> [AFBudget]
    
    func create(form: AddBudgetForm) async throws -> AFBudget
    
    func delete(id: String) async throws
    
}

struct AddBudgetForm {
    
    var value: String = ""
    
    var date: String = ""
    
}
