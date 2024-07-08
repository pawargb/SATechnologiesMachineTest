//
//  RefreshInspectionAPIResponse.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 08/07/24.
//

import Foundation

// MARK: - Welcome
struct RefreshInspectionAPIResponse: Codable {
    let inspection: Inspection
}

// MARK: - Inspection
struct Inspection: Codable {
    let area: Area
    let id: Int
    let inspectionType: InspectionType
    let survey: Survey
}

// MARK: - Area
struct Area: Codable {
    let id: Int
    let name: String
}

// MARK: - InspectionType
struct InspectionType: Codable {
    let access: String
    let id: Int
    let name: String
}

// MARK: - Survey
struct Survey: Codable {
    let categories: [Category]
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let answerChoices: [AnswerChoice]
    let id: Int
    let name: String
    let selectedAnswerChoiceID: Int?

    enum CodingKeys: String, CodingKey {
        case answerChoices, id, name
        case selectedAnswerChoiceID = "selectedAnswerChoiceId"
    }
}

// MARK: - AnswerChoice
struct AnswerChoice: Codable {
    let id: Int
    let name: String
    let score: Double
}
