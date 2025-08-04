//
//  AuthServiceProtocol.swift
//  AppFinances
//
//  Created by Edgar on 23/06/25.
//

import FirebaseAuth

protocol AuthServiceProtocol: AnyObject {
    
    var user: AFUser? {
        get
    }
    
    func authenticate(form: LoginForm) async throws(Error) -> AFUser
    
    func updateUserDisplayName(_ newDisplayName: String) async throws(Error)
    
    func getUserId() throws -> String
    
    func logout() async throws
        
}

struct LoginForm {
    
    var username: String = ""
    
    var email: String = ""
    
    var password: String = ""
    
}

struct AFUser {
    
    var name: String?

    var email: String?

    var avatar: String?
    
}

// MARK: Firebase
extension AFUser {
    static func fromFirebase(user: User) -> Self {
        return .init(name: user.displayName, email: user.email, avatar: user.photoURL?.absoluteString)
    }
}
