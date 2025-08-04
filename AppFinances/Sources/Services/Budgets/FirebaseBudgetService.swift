//
//  FirebaseEntryService.swift
//  AppFinances
//
//  Created by Edgar on 18/07/25.
//


import FirebaseFirestore
import FirebaseAuth

class FirebaseBudgetService: FirebaseAuthService, BudgetsServiceProtocol {
    
    private let budgetCollectionName = "budgets"
    
    
    func getBudget(by monthYear: AFMonthYear) async throws -> AFBudget? {
        let userId = try getUserId()
        
        let budgetRef = try await db.collection(budgetCollectionName)
            .whereField("userId", isEqualTo: userId)
            .whereField("month", isEqualTo: monthYear.month)
            .whereField("year", isEqualTo: monthYear.year)
            .getDocuments()
        
        let budget = try budgetRef.documents.first?.data(as: AFBudget.self)
        
        return budget
        
    }
    
    func getBudgets() async throws -> [AFBudget] {
        let userId = try getUserId()
        
        let budgetRef = try await db.collection(budgetCollectionName)
            .whereField("userId", isEqualTo: userId)
            .order(by: "year", descending: true)
            .order(by: "month", descending: true)
            .getDocuments()
        
        
        let budgets = budgetRef.documents.compactMap {  try! $0.data(as: AFBudget.self) }
        
        return budgets
    }
    
    func exists(form: AddBudgetForm) async throws -> AFBudget? {
        let userId = try getUserId()
        let newBudget = try AFBudget.from(userId: userId, addBudgetForm: form)
        
        let budgetRef = try await db.collection(budgetCollectionName)
            .whereField("month", isEqualTo: newBudget.month)
            .whereField("year", isEqualTo: newBudget.year)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        let budget = try budgetRef.documents.first?.data(as: AFBudget.self)
        
        return budget
    }
    
    func create(form: AddBudgetForm) async throws -> AFBudget {
        let userId = try getUserId()
        
        let budget = try await exists(form: form)
        
        if var budget {
            guard let value = form.value.currencyToDouble() else {
                throw AFError.invalidForm
            }
            budget.limit = value
            try db.collection(budgetCollectionName).document(budget.id!).setData(from: budget)
            return budget
        } else {
            let newBudget = try AFBudget.from(userId: userId, addBudgetForm: form)
            try db.collection(budgetCollectionName).addDocument(from: newBudget)
            return newBudget
        }
    }
    
    func delete(id: String) async throws {
        try await db.collection(budgetCollectionName).document(id).delete()
    }
}
