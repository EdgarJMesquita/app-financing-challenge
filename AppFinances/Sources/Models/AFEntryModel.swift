//
//  EntryModel.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import Foundation
import UIKit
import FirebaseFirestore

struct AFEntry: Codable {
    enum Category: String, Codable, CaseIterable {
        case income
        case gift
        case grocery
        case bill
        case rent
    }
    
    enum AFType: String, Codable {
        case income
        case expense
    }
    
    @DocumentID var id: String?
    let userId: String
    let category: Category
    let type: AFType
    let description: String
    let dueAt: Date
    let value: Double
    let month: Int
    let year: Int
    
    func getImage() -> UIImage {
        switch self.category {
        case .income:
            return .afBriefcase
        case .gift:
            return .afGift
        case .grocery:
            return .afBasket
        case .bill:
            return .afNoteWithText
        case .rent:
            return .afHome
        }
    }
}


extension AFEntry.Category {
    
    static func getOptions() -> [String] {
        return Self.allCases.compactMap { $0.getTitle() }
    }
    
    func getTitle() -> String {
        switch self {
        case .income:
            return "Salário"
        case .gift:
            return "Presente"
        case .grocery:
            return "Mercado"
        case .bill:
            return "Conta"
        case .rent:
            return "Aluguel"
        }
    }
    
    static func fromTitle(_ title: String) -> Self {
        switch title {
        case "Salário":
            return .income
        case "Presente":
            return .gift
        case "Mercado":
            return .grocery
        case "Conta":
            return .bill
        case "Aluguel":
            return .rent
        default:
            return .bill
        }
    }
}

// MARK: mapping from AddEntryForm
extension AFEntry {
    static func from(userId: String, addEntryForm: AddEntryForm) throws -> Self {
        let category: AFEntry.Category = .fromTitle(addEntryForm.category)
        
        guard let value = addEntryForm.value.currencyToDouble() else {
            throw AFError.invalidForm
        }
        
        guard
            let date = addEntryForm.date.toDate() else {
            throw AFError.invalidForm
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        
        return AFEntry(
            userId: userId,
            category: category,
            type: addEntryForm.type,
            description: addEntryForm.description,
            dueAt: date,
            value: value,
            month: dateComponents.month!,
            year: dateComponents.year!
        )
    }
}
