//
//  AuthService.swift
//  App de Finanças
//
//  Created by Edgar on 23/06/25.
//

import FirebaseAuth

class FirebaseAuthService: FirebaseDatabaseService, AuthServiceProtocol {

    var user: AFUser? {
        if let firebaseUser = Auth.auth().currentUser {
            return .fromFirebase(user: firebaseUser)
        }
        return nil
    }
    
    func getUserId() throws -> String {
        guard let userId = Auth.auth().getUserID() else {
            throw AFError.unauthorized
        }
        return userId
    }
    
    func authenticate(form: LoginForm) async throws -> AFUser {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AFUser, Error>) in
            Auth.auth().signIn(withEmail: form.email, password: form.password) { result, error in
          
                guard let result else {
                    continuation.resume(throwing: error ?? NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not available"]))
                    return
                }
                    
                continuation.resume(returning: .fromFirebase(user: result.user))
            }
        }
    }
    
    func updateUserDisplayName(_ newDisplayName: String) async throws {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void,Error>) in
            guard let user = Auth.auth().currentUser else {
                continuation.resume(throwing: AFError.unauthorized)
                return
            }
            
            let changeRequest = user.createProfileChangeRequest()
            
            changeRequest.displayName = newDisplayName
            
            changeRequest.commitChanges { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func logout() async throws {
        try Auth.auth().signOut()
    }
}




