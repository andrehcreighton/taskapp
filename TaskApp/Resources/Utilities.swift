//
//  Utilities.swift
//  TaskApp
//
//  Created by Andre Creighton on 3/24/21.
//

import Foundation
import Firebase

struct Utilities {
  
  // at least one uppercase,
  // at least one digit
  // at least one lowercase
  // 8 characters total
  static func isPasswordValid(_ password: String) -> Bool {
    
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
    
    return passwordTest.evaluate(with: password)
  }
  
  static func isEmailValid(_ email: String) -> Bool {
    
    let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", regEx)
    
    return emailTest.evaluate(with: email)
  }
  
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .userNotFound:
            return "No user associated by this email"
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak"
        case .wrongPassword:
            return "Incorrect Password."
        default:
            return "Unknown error occurred"
        }
    }
}


