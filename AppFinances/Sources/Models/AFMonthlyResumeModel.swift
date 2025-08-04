//
//  AFMonthlyResumeModel.swift
//  AppFinances
//
//  Created by Edgar on 18/07/25.
//

struct AFMonthlyResume {
    var entries: [AFEntry]
    var budget: AFBudget?
    var used: Double
    
    var percent: Double? {
        guard let budget else {
            return nil
        }
        
        return used / budget.limit
    }
    
    var available: Double? {
        guard let budget else {
            return nil
        }
        
        return budget.limit - used
    }
    
}
