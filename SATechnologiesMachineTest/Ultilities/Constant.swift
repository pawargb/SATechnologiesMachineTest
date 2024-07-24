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
        static let submitUrl = "/api/inspections/submit"
    }
    struct CellIdentifier {
        static let inspectionListTableViewCell = "InspectionListTableViewCell"
        static let answerChoiceTableViewCell = "AnswerChoiceTableViewCell"
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
    
    struct EntityNames {
        static let answerChoiceEntity = "AnswerChoiceEntity"
        static let inspectionAreaEntity = "InspectionAreaEntity"
        static let inspectionEntity = "InspectionEntity"
        static let inspectionTypeEntity = "InspectionTypeEntity"
        static let questionsEntity = "QuestionsEntity"
        static let surveyCategoryEntity = "SurveyCategoryEntity"
    }
}
