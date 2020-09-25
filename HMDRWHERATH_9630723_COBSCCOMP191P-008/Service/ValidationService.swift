//
//  ValidationService.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/25/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import Foundation

struct ValidationService {
    func validateEmail(_ email: String?) throws -> String {
        guard let email = email else { throw ValidationError.invalidValue }
        guard isValidEmail(email) else { throw ValidationError.invalidEmail }
        return email
    }
    
    func validatePassword(_ password: String?) throws -> String {
        guard let password = password else { throw ValidationError.invalidValue }
        guard password.count >= 6 else { throw ValidationError.passwordTooShort }
        return password
    }
    
    func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: email)
}
}

enum ValidationError: LocalizedError {
    case invalidValue
    case invalidEmail
    case passwordTooShort
    
    var errorDescription: String? {
        switch self {
        case .invalidValue:
            return "You have entered invalid value"
        case .invalidEmail:
            return "Your email format is wrong"
        case .passwordTooShort:
            return "Your password is too short"
        }
    }
}
