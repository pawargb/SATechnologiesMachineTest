//
//  InspectionViewModel.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 08/07/24.
//

import Foundation

class InspectionViewModel {
    var inspection :InspectionEntity? {
        didSet {
            if let categories = self.inspection?.surveyCategory?.allObjects as? [SurveyCategoryEntity] {
                self.categories = categories
            }
        }
    }
    var categories: [SurveyCategoryEntity] = [SurveyCategoryEntity]()
    var score: Double = 0.0
    
    func areAllAnswerSelected() -> Bool {
        for category in categories {
            if let questions = category.questions?.allObjects as? [QuestionsEntity] {
                for question in questions {
                    if question.selectedAnswerChoiceId == 0 {
                        return false
                    }
                }
            }
        }
            
        return true
    }

    func submitInspection(completionHandler: ((Result<Bool, Error>) -> Void)?) {
        let apiParameters = getParameter()
        
        APIManager.postAction(url: Constant.url.submitUrl, parameters: apiParameters, apiMethod: .post) { [weak self] (data, urlResponse, _) in
            
            guard let self = self, let httpResponse = urlResponse as? HTTPURLResponse else {
                completionHandler?(.failure(APIError.other(message: Constant.apiError.somethingWentWrong)))
                return
            }
            
            if httpResponse.statusCode == 200 {
                self.inspection?.status = InspectionStatus.completed.rawValue
                CoreDataManager.shared.saveContext()
                completionHandler?(.success(true))
            } else {
                completionHandler?(.failure(APIError.other(message: Constant.apiError.somethingWentWrong)))
            }
        }
    }
    
    func getParameter() -> RefreshInspectionAPIResponse {
        var categoriesAPIModel = [Category]()
        for category in self.categories {
            let questionsAPIModel = [Question]()
            if let questions = category.questions?.allObjects as? [QuestionsEntity] {
                
                for question in questions {
                    var answerChoicesAPIModel = [AnswerChoice]()
                    if let answerChoices = question.answerChoices?.allObjects as? [AnswerChoiceEntity] {

                        for answerChoice in answerChoices {
                            let answerChoiceAPIModel = AnswerChoice(id: Int(answerChoice.id), name: answerChoice.name ?? "", score: answerChoice.score)
                            if answerChoice.id == question.selectedAnswerChoiceId {
                                score += answerChoice.score
                            }
                            answerChoicesAPIModel.append(answerChoiceAPIModel)
                        }
                    }
                    let questionAPIModel = Question(answerChoices: answerChoicesAPIModel, id: Int(question.id), name: question.name ?? "", selectedAnswerChoiceID: Int(question.selectedAnswerChoiceId))
                }
            }
            
            let categoryAPIModel = Category(id: Int(category.id), name: category.name ?? "", questions: questionsAPIModel)
            categoriesAPIModel.append(categoryAPIModel)
        }
        let inspectionSurvey = Survey(categories: categoriesAPIModel)
        let inspectionType = InspectionType(access: self.inspection?.inspectionType?.access ?? "", id: Int(self.inspection?.inspectionType?.id ?? 0), name: self.inspection?.inspectionType?.name ?? "")
        let inspectionArea = Area(id: Int(self.inspection?.inspectionArea?.id ?? 0), name: self.inspection?.inspectionArea?.name ?? "")
        let inspection = Inspection(area: inspectionArea, id: Int(self.inspection?.id ?? 0), inspectionType: inspectionType, survey: inspectionSurvey)
        let inspectionBody = RefreshInspectionAPIResponse(inspection: inspection)
        self.inspection?.score = self.score
        CoreDataManager.shared.saveContext()
        return inspectionBody
    }
}
