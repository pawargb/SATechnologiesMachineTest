//
//  APIManager.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import Foundation

enum APIMethods: String {
    case get = "GET"
    case post = "POST"
}

class APIManager {
    
    static func postAction(url: String, parameters: APIRequest?, apiMethod: APIMethods, completion: ((Data?, URLResponse?, Error?) -> Void)?)  {
        
        let fullURL = Constant.url.baseURL + url
        let Url = String(format: fullURL)
        guard let serviceUrl = URL(string: Url) else { return }
        
        var request = URLRequest(url: serviceUrl)
        
        request.httpMethod = apiMethod.rawValue
        
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if let requestWithParameters = parameters, let body = try? JSONEncoder().encode(requestWithParameters) {
            
            request.httpBody = body
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion?(data, response, error)
            }
        }.resume()
    }
}
