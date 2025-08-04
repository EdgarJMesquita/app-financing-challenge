//
//  MonthlyResumeModel.swift
//  AppFinances
//
//  Created by Edgar on 13/07/25.
//

import Foundation
import FirebaseFirestore

struct AFBudget: Codable {
    
    @DocumentID var id: String?
    
    var month: Int
    var year: Int

    var limit: Double
    var userId: String

    static func from(userId: String, addBudgetForm: AddBudgetForm) throws -> Self {
        
        guard
            let date = addBudgetForm.date.toDate(dateFormat: "MM/yyyy") else {
            throw AFError.invalidForm
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        
        guard let valueDouble = addBudgetForm.value.currencyToDouble() else {
            throw AFError.invalidForm
        }
        
        return .init(month: dateComponents.month!, year: dateComponents.year!, limit: valueDouble, userId: userId)
    }
    
    var isPast: Bool {
        
        let calendar = Calendar.current
        
        let nowDateComponents = calendar.dateComponents([.month, .year], from: .now)
        
        guard
            let nowMonth = nowDateComponents.month,
            let nowYear = nowDateComponents.year else {
            return false
        }
        
        return month < nowMonth && year <= nowYear
      
    }
}
