//
//  LoginAPIRequestModel.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import Foundation

protocol APIRequest: Codable {
    
}

class LoginAPIRequestModel: APIRequest {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

