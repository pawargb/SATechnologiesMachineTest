//
//  CustomAlertController.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import UIKit

class CustomAlertController {
    static func present(title: String, message: String, action: (() -> Void)? = nil) { 
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            action?()
        }
        alertController.addAction(okAction)
        UIApplication.getTopViewController()?.present(alertController, animated: true)
    }
}
