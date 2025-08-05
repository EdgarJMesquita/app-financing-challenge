//
//  FirebaseEntryService.swift
//  AppFinances
//
//  Created by Edgar on 18/07/25.
//


import FirebaseFirestore
import FirebaseAuth

class FirebaseEntryService: FirebaseAuthService, EntryServiceProtocol {
    
    private let entriesCollectionName = "entries"

    
    func getEntries(by monthYear: AFMonthYear) async throws(any Error) -> [AFEntry] {
        let userId = try getUserId()
        
        let entriesRef = db.collection(entriesCollectionName)
        let query = entriesRef
            .whereField("userId", isEqualTo: userId)
            .whereField("month", isEqualTo: monthYear.month)
            .whereField("year", isEqualTo: monthYear.year)
        
        let snapshot = try await query.getDocuments()
        
        let entries = snapshot.documents.compactMap {  try! $0.data(as: AFEntry.self) }
        
        return entries
    }
    
    func create(form: AddEntryForm) async throws -> AFEntry {
        let userId = try getUserId()
        
        var newEntry = try AFEntry.from(userId: userId, addEntryForm: form)

        let ref = try db.collection(entriesCollectionName).addDocument(from: newEntry)
        newEntry.id = ref.documentID
        return newEntry
    }
    
    func delete(id: String) async throws {
        let _ = try getUserId()
        
        try await db.collection(entriesCollectionName).document(id).delete()
    }
}


enum AFError: Error {
    case unauthorized
    case serverError(code: Int)
    case custom(message: String)
    case invalidForm
}
