//
//  AddEntryViewModel.swift
//  AppFinances
//
//  Created by Edgar on 21/07/25.
//
import UserNotifications

class AddEntryViewModel {
    let service: EntryServiceProtocol
    
    init(service: EntryServiceProtocol) {
        self.service = service
    }
    
    func createNewEntry(form: AddEntryForm) async throws -> AFEntry {
        let entry = try await service.create(form: form)
        scheduleNotification(for: entry)
        return entry
    }
    
    private func scheduleNotification(for entry: AFEntry){
        UserNotificationsManager.shared.scheduleNotification(for: entry)
    }
}
