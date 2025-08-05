//
//  UserDefaultsManager 2.swift
//  AppFinances
//
//  Created by Edgar on 05/08/25.
//

import UserNotifications


class UserNotificationsManager {
    static let shared = UserNotificationsManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init(){}
    
    
    func checkPermission() async throws -> Bool {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    continuation.resume(returning: true)
                case .denied:
                    continuation.resume(returning: false)
                case .notDetermined:
                    continuation.resume(returning: false)
                case .provisional:
                    continuation.resume(returning: false)
                case .ephemeral:
                    continuation.resume(returning: true)
                @unknown default:
                    continuation.resume(throwing: AFError.custom(message: "Unknown authorizationStatus: \(settings.authorizationStatus)"))
                }
            }
        }
   
    }
    
    func requestPermission() async throws {
        return try await withCheckedThrowingContinuation { (continuation:CheckedContinuation<Void, Error>) in
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    continuation.resume()
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: AFError.unauthorized)
                }
            }
        }
    
    }
    
    
    func scheduleNotification(for entry: AFEntry){
        Task {
            do {
                let hasPermission = try await checkPermission()
                
                if !hasPermission {
                    try await requestPermission()
                }
                
                let calendar = Calendar.current
                
                
                guard
                    calendar.isDateInToday(entry.dueAt) || entry.dueAt > .now
                else {
                    print("Entry's dueAt it's in the past.")
                    return
                }
                
                let notificationCenter = UNUserNotificationCenter.current()
                
                
                
                let content = UNMutableNotificationContent()

                content.title = " \(entry.type == .expense ? "Conta" : "Recebimento"): \(entry.description)"
                content.body = "\(entry.description) vai \(entry.type == .expense ? "vencer" : "receber") hoje."
                content.sound = .default
                
                var dateComponents = calendar.dateComponents([.day, .month, .year], from: entry.dueAt)
                
                if calendar.isDateInToday(entry.dueAt),
                   let dateNow = calendar.date(byAdding: .minute, value: 2, to: .now)
                {
                    let dateComponentsNow = calendar.dateComponents([.hour, .minute], from: dateNow)
                    dateComponents.hour = dateComponentsNow.hour
                    dateComponents.minute = dateComponentsNow.minute
                } else {
                    dateComponents.hour = 10
                }
          
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                guard let id = entry.id else {
                    return
                }
                
                let request = UNNotificationRequest(identifier: id, content: content , trigger: trigger)
                
                try await notificationCenter.add(request)
            } catch {
                print(error)
            }
        }
        
    }

}
