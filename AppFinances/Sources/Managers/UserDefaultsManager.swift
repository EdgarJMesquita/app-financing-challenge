//
//  UserDefaultsManager.swift
//  AppFinances
//
//  Created by Edgar on 31/07/25.
//

import Foundation
import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let kUserPhoto = "user.photo"
    private let kUserEmail = "user.email"
    
    private init(){}
    
    func saveUserPhoto(image: UIImage){
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        userDefaults.set(data, forKey: kUserPhoto)
    }
    
    func getUserPhoto() -> UIImage? {
        guard let data = userDefaults.data(forKey: kUserPhoto) else {
            return nil
        }
        
        return .init(data: data)
    }
    
    func saveUserEmail(_ email: String){
        userDefaults.set(email, forKey: kUserEmail)
    }
    
    func getUserEmail() -> String? {
        return userDefaults.string(forKey: kUserEmail)
    }
    
    func clear(){
        userDefaults.removeObject(forKey: kUserEmail)
        userDefaults.removeObject(forKey: kUserPhoto)
    }
}
