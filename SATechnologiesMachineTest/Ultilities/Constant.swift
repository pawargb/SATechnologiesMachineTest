//
//  Constant.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import Foundation

struct Constant {
    struct url {
        static let baseURL = "http://localhost:5001"
        static let loginURL = "/api/login"
        static let signUp = "/api/register"
        static let refreshInspection = "/api/random_inspection"
    }
    struct CellIdentifier {
        static let inspectionListTableViewCell = "InspectionListTableViewCell"
    }
    struct apiError {
        static let somethingWentWrong = "Something went wrong"
        static let inspectionNotGenerated = "The inspections have not already been generated"
    }
    struct userDefaultKey {
        static let isUserLoggedIn = "isUserLoggedIn"
    }
    
    struct ViewControllerNames {
        static let homeViewController = "HomeViewController"
        static let loginViewController = "LoginViewController"
        static let homeNavigationController = "HomeNavigationController"
        static let inspectionViewController = "InspectionViewController"
    }
    
    struct TitleString {
        static let login = "Login"
        static let signUp = "Sign Up"
    }
}
