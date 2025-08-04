//
//  MonthYear.swift
//  AppFinances
//
//  Created by Edgar on 04/07/25.
//

import Foundation

struct AFMonthYear: Equatable {
    
    let month: Int
    let year: Int

    var formatted: String {
        if let date {
            let formattedMonth = date
                .formatted(.dateTime.month(.abbreviated))
                .uppercased()
                .replacingOccurrences(of: ".", with: "")
            
            let formattedYear = date.formatted(.dateTime.year(.twoDigits))
            
            return isCurrentYear ? "\(formattedMonth)" : "\(formattedMonth)/\(formattedYear)"
            
        } else {
            return isCurrentYear ? "\(month)" : "\(month)/\(year)"
        }
        
    }
    
    var formattedMonth: String {
        if let date {
            return date.formatted(.dateTime.month(.wide))
                .uppercased()
                .replacingOccurrences(of: ".", with: "")
        } else {
            return "\(month)"
        }
    }
    
    var isCurrentYear: Bool {
        guard let date else {
            return false
        }
        
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year)
    }
    
    var date: Date? {
        var components = DateComponents()
        components.month = month
        components.year = year
        
        return Calendar.current.date(from: components)
    }
    
    static func from(date: Date) -> Self {
        let components = Calendar.current.dateComponents([.year,.month], from: date)
        
        let monthYear = self.init(month: components.month!, year: components.year!)
        return monthYear
    }
    
    func next() -> AFMonthYear? {
        guard
            let date,
            let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: date)
        else {
            return nil
        }
        
        return .from(date: nextDate)
    }
    
    func previous() -> AFMonthYear? {
        guard
            let date,
            let nextDate = Calendar.current.date(byAdding: .month, value: -1, to: date)
        else {
            return nil
        }
        
        return .from(date: nextDate)
    }
    
    func isAfter(date comparedDate: Date) -> Bool {
        guard let date else {
            return false
        }
        
        return date > comparedDate
    }
    
}
