//
//  LoginViewModel.swift
//  AppFinances
//
//  Created by Edgar on 23/06/25.
//

import LocalAuthentication
import Security

class LoginViewModel {
    
    let service : AuthServiceProtocol
    
    
    init(service: AuthServiceProtocol) {
        self.service = service
    }

    func authenticate(form: LoginForm) async throws(any Error) -> AFUser {
        try await service.authenticate(form: form)
    }
    
    func checkBiometricAvailability() -> Bool {
        let context = LAContext()
        var authError: NSError?
        
        let hasPolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        
        return hasPolicy
    }
    
    func saveUserLoginWithBiometric(email: String, password: String) {
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            .userPresence,
            nil
        )
        
        let context = LAContext()
        context.localizedReason = "Entrar com biometria."
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: email,
            kSecAttrServer as String: "com.edgar.App-de-Financ-as",
            kSecAttrAccessControl as String: accessControl as Any,
            kSecUseAuthenticationContext as String: context,
            kSecValueData as String: password.data(using: .utf8) as Any
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            return
        }
       
        UserDefaultManager.shared.saveUserEmail(email)
    }

    typealias BiometricResult = (email: String, password: String)
    
    func checkBiometricLogin() async throws -> BiometricResult  {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<BiometricResult, any Error>) in
            guard checkBiometricAvailability() else {
                continuation.resume(throwing: AFError.custom(message: "Não é possível usar biometria neste momento."))
                return
            }
            guard let userEmail = UserDefaultManager.shared.getUserEmail() else {
                continuation.resume(throwing: AFError.custom(message: "Não há senha salva."))
                return
            }
            
            let context = LAContext()
            context.localizedReason = "Access your password on the keychain"
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrServer as String: "com.edgar.App-de-Financ-as",
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnAttributes as String: true,
                kSecUseAuthenticationContext as String: context,
                kSecReturnData as String: true
            ]
            
            var item: CFTypeRef?

            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            if
                status == errSecSuccess,
                let existingItem = item as? [String: Any],
                let passwordData = existingItem[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: .utf8)
            {
                continuation.resume(returning: (userEmail, password))
                return
            }

            if status == errSecUserCanceled {
                continuation.resume(throwing: AFError.custom(message: "Biometria cancelada."))
                return
            }
            
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "Algo aconteceu, não foi possível entrar com biometria."
            continuation.resume(throwing: AFError.custom(message: errorMessage))
        }
    }
}

protocol LoginViewModelDelegate: AnyObject {
    
}
