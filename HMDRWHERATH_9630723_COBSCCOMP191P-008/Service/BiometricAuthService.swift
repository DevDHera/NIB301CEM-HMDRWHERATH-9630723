//
//  BiometricAuthService.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/26/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricAuthService {
    let context = LAContext()
    var loginReason = "Logging in with "
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    func canEvaluvatePolicy() -> Bool {
        return context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            loginReason = loginReason + "TouchID"
            return .touchID
        case .faceID:
            loginReason = loginReason + "FaceID"
            return .faceID
        }
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        guard canEvaluvatePolicy() else {
            completion("Biometric auth not available.")
            return
        }
        
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                let message: String
                
                switch error {
                case LAError.authenticationFailed?:
                    message = "Identity not verified"
                case LAError.userCancel?:
                    message = "User cancelled"
                case LAError.userFallback?:
                    message = "User choose to use passcode"
                case LAError.biometryNotAvailable?:
                    message = "FaceID / TouchID not available on device"
                case LAError.biometryNotEnrolled?:
                    message = "FaceID / TouchID not enrolled on device"
                case LAError.biometryLockout?:
                    message = "FaceID / TouchID locked out on device"
                default:
                    message = "FaceID / TouchID may not be configured"
                }
                completion(message)
            }
        }
    }
}
