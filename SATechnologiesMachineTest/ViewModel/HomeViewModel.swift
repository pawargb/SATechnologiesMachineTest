//
//  HomeViewModel.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 08/07/24.
//

import Foundation

class HomeViewModel {
    
    
    var inpsection :RefreshInspectionAPIResponse?
    
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
                        self.inpsection = try JSONDecoder().decode(RefreshInspectionAPIResponse.self, from: data)
                        
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
}
