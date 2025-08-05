//
//  HomeViewModel.swift
//  AppFinances
//
//  Created by Edgar on 30/07/25.
//

import FirebaseAuth

class HomeViewModel {
    private let service: AuthServiceProtocol
    let user: AFUser?
    
    init(service: AuthServiceProtocol) {
        self.service = service
        self.user = service.user
    }
    
    func updateDisplayName(_ name: String){
        Task {
            try await service.updateUserDisplayName(name)
        }
    }
    
    func saveUserPhoto(image: UIImage){
        UserDefaultsManager.shared.saveUserPhoto(image: image)
    }
    
    func getUserPhoto() -> UIImage? {
        return UserDefaultsManager.shared.getUserPhoto()
    }
    
    func logout() async throws {
        try await service.logout()
        UserDefaultsManager.shared.clear()
    }
}
