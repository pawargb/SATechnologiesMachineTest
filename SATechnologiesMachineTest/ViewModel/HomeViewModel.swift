//
//  HomeViewModel.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 08/07/24.
//

import Foundation

enum InspectionStatus: Int64 {
    case new = 1
    case inProgress = 2
    case completed = 3
}

class HomeViewModel {
    
    var inspectionArray: [InspectionEntity] = [InspectionEntity](){
        didSet{
            self.filteredArray = self.inspectionArray.filter({$0.status == self.selectedInspectionFilter.rawValue})
        }
    }
    var filteredArray: [InspectionEntity] = [InspectionEntity]()
    var selectedInspectionFilter: InspectionStatus = .new {
        didSet{
            self.filteredArray = self.inspectionArray.filter({$0.status == self.selectedInspectionFilter.rawValue})
        }
    }
    //MARK: - API methods
    
    func refreshInspectionAPI(completionHandler: ((Result<Bool, Error>) -> Void)?) {
        
        APIManager.postAction(url: Constant.url.refreshInspection, parameters: nil, apiMethod: .get) { [weak self] (data, urlResponse, _) in
            
            guard let self = self, let httpResponse = urlResponse as? HTTPURLResponse else {
                completionHandler?(.failure(APIError.other(message: Constant.apiError.somethingWentWrong)))
                return
            }
            
            if httpResponse.statusCode == 200 {
                
                if let data = data {
                    do {
                        let inpsection = try JSONDecoder().decode(RefreshInspectionAPIResponse.self, from: data)
                        saveResponseToDatabase(inspection: inpsection)
                        completionHandler?(.success(true))
                    } catch {
                        completionHandler?(.failure(error))
                    }
                }
                
                completionHandler?(.success(true))
            } else if httpResponse.statusCode == 404 {
                completionHandler?(.failure(APIError.other(message: Constant.apiError.inspectionNotGenerated)))
            } else {
                completionHandler?(.failure(APIError.other(message: Constant.apiError.somethingWentWrong)))
            }
        }
    }
    
    func saveResponseToDatabase(inspection: RefreshInspectionAPIResponse) {
        let coreDataManager = CoreDataManager.shared
        if let inspectionEntity = coreDataManager.createData(entityName: Constant.EntityNames.inspectionEntity) as? InspectionEntity {
            inspectionEntity.id = Int16(inspection.inspection.id)
            inspectionEntity.status = InspectionStatus.new.rawValue
            if let areaEntity = coreDataManager.createData(entityName: Constant.EntityNames.inspectionAreaEntity) as? InspectionAreaEntity {
                areaEntity.id = Int64(inspection.inspection.area.id)
                areaEntity.name = inspection.inspection.area.name
                inspectionEntity.inspectionArea = areaEntity
            }
            if let inspectionTypeEntity = coreDataManager.createData(entityName: Constant.EntityNames.inspectionTypeEntity) as? InspectionTypeEntity {
                let inspectionType = inspection.inspection.inspectionType
                inspectionTypeEntity.id = Int64(inspectionType.id)
                inspectionTypeEntity.access = inspectionType.access
                inspectionTypeEntity.name = inspectionType.name
                inspectionEntity.inspectionType = inspectionTypeEntity
            }
            
            let surveyCategories = inspection.inspection.survey.categories
            
            for surveyCategory in surveyCategories {
                if let surveyCategoryEntity = coreDataManager.createData(entityName: Constant.EntityNames.surveyCategoryEntity) as? SurveyCategoryEntity {
                    surveyCategoryEntity.id = Int64(surveyCategory.id)
                    surveyCategoryEntity.name = surveyCategory.name
                    inspectionEntity.addToSurveyCategory(surveyCategoryEntity)

                    for question in surveyCategory.questions {
                        if let questionEntity = coreDataManager.createData(entityName: Constant.EntityNames.questionsEntity) as? QuestionsEntity {
                            questionEntity.id = Int64(question.id)
                            questionEntity.name = question.name
                            questionEntity.selectedAnswerChoiceId = Int64(question.selectedAnswerChoiceID ?? 0)
                            surveyCategoryEntity.addToQuestions(questionEntity)

                            for answerChoice in question.answerChoices {
                                if let answerChoiceEntity = coreDataManager.createData(entityName: Constant.EntityNames.answerChoiceEntity) as? AnswerChoiceEntity {
                                    answerChoiceEntity.id = Int64(answerChoice.id)
                                    answerChoiceEntity.name = answerChoice.name
                                    answerChoiceEntity.score = answerChoice.score
                                    questionEntity.addToAnswerChoices(answerChoiceEntity)
                                }
                            }
                        }
                    }
                }
            }
            inspectionArray.append(inspectionEntity)
        }
        coreDataManager.saveContext()        
    }
    
    func fetchInspectionFromDB() {
        inspectionArray = CoreDataManager.shared.retrieveData(entityName: Constant.EntityNames.inspectionEntity) as? [InspectionEntity] ?? []
    }
    
    func getCount(for status: InspectionStatus) -> Int {
        return inspectionArray.filter({ $0.status == status.rawValue }).count
    }
}
