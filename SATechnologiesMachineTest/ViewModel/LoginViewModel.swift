//
//  LoginViewModel.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import Foundation

class LoginViewModel {
    
    
    //MARK: - API methods
    
    func loginAPI(loginDetails: LoginAPIRequestModel, completionHandler: ((Result<Bool, Error>) -> Void)?) {
        
        APIManager.postAction(url: Constant.url.loginURL, parameters: loginDetails, apiMethod: .post) { [weak self] (data, urlResponse, _) in
            
            guard let self = self, let httpResponse = urlResponse as? HTTPURLResponse else {
                completionHandler?(.failure(APIError.other(message: Constant.apiError.somethingWentWrong)))
                return
            }
            
            if httpResponse.statusCode == 200 {
                
                LoginManager.shared.markUserLogged()
                completionHandler?(.success(true))
            } else {
                if let data = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(LoginAPIResponseModel.self, from: data)
                        let error = APIError.other(message: jsonResponse.error ?? Constant.apiError.somethingWentWrong)
                        
                        completionHandler?(.failure(error))
                        
                    } catch {
                        completionHandler?(.failure(error))
                    }
                }
            }
        }
    }
    
    func signUpAPI(signUpDetails: LoginAPIRequestModel, completionHandler: ((Result<Bool, Error>) -> Void)?) {
        
        APIManager.postAction(url: Constant.url.signUp, parameters: signUpDetails, apiMethod: .post) { [weak self] (data, urlResponse, _) in
            
            guard let self = self, let httpResponse = urlResponse as? HTTPURLResponse else {
                completionHandler?(.failure(APIError.other(message: Constant.apiError.somethingWentWrong)))
                return
            }
            
            if httpResponse.statusCode == 200 {
                
                LoginManager.shared.markUserLogged()
                completionHandler?(.success(true))
            } else {
                if let data = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(LoginAPIResponseModel.self, from: data)
                        let error = APIError.other(message: jsonResponse.error ?? Constant.apiError.somethingWentWrong)
                        
                        completionHandler?(.failure(error))
                        
                    } catch {
                        completionHandler?(.failure(error))
                    }
                }
            }
        }
    }
}
