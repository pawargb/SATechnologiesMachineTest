//
//  APIError.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import Foundation

enum APIError: LocalizedError {
    case other(message: String)
    
    var errorDescription: String? {
        switch self {
        case .other(let message): return message
        }
    }
}
