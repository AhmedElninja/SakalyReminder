//
//  Validator.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 24/06/2023.
//

import Foundation

class Validator {
    
    //Mark: - Singltone.
    private static let sharedInstance = Validator()
    
    static func shared() -> Validator {
        return Validator.sharedInstance
    }
    
    //Mark: - Propreties.
    private let format = "SELF MATCHES %@"
    
    //Mark: - Methods.
    func isValidEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: email)
    }
    func isValidPassword(password: String) -> Bool {
        let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: password)
    }
}
