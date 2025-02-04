//
//  StringExtensions.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import Foundation

extension String {
    
    var isEmailValid: Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: self)
    }
}
