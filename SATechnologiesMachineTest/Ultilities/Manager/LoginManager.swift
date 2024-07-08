//
//  LoginManager.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import Foundation


class LoginManager {
    
    static let shared = LoginManager()
    
    let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func markUserLogged() {
        userDefaults.set(true, forKey: Constant.userDefaultKey.isUserLoggedIn)
        userDefaults.synchronize()
    }
    
    func markUserLoggedOut() {
        userDefaults.set(false, forKey: Constant.userDefaultKey.isUserLoggedIn)
        userDefaults.synchronize()
    }
    
    func isUserLoggedIn() -> Bool {
        UserDefaults.standard.bool(forKey: Constant.userDefaultKey.isUserLoggedIn)
    }
}
