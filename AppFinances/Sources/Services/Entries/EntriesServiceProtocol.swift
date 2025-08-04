//
//  EntriesServiceProtocol.swift
//  AppFinances
//
//  Created by Edgar on 18/07/25.
//

protocol EntryServiceProtocol: AnyObject {
    
    func getEntries(by monthYear: AFMonthYear) async throws -> [AFEntry]
    
    func create(form: AddEntryForm) async throws -> AFEntry
    
    func delete(id: String) async throws
    
}

struct AddEntryForm {
    
    var description: String = ""
    
    var category: String = ""
    
    var value: String = ""
    
    var date: String = ""
    
    var type: AFEntry.AFType = .income
    
}
