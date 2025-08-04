//
//  AddEntryViewModel.swift
//  AppFinances
//
//  Created by Edgar on 21/07/25.
//

class AddEntryViewModel {
    let service: EntryServiceProtocol
    
    init(service: EntryServiceProtocol) {
        self.service = service
    }
    
    func createNewEntry(form: AddEntryForm) async throws -> AFEntry {
        try await service.create(form: form)
    }
}
