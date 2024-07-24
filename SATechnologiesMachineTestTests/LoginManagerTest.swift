//
//  LoginManagerTest.swift
//  SATechnologiesMachineTestTests
//
//  Created by Ganesh Pawar on 17/07/24.
//

import XCTest

final class LoginManagerTest: XCTestCase {

    var sut: LoginManager?
    
    override func setUp() {
        super.setUp()
        sut = LoginManager.shared
        
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.removeObject(forKey: Constant.userDefaultKey.isUserLoggedIn)
        sut = nil
    }
    
    func testMarkUserLoggedIn() {
        sut?.markUserLogged()
        XCTAssertTrue(UserDefaults.standard.bool(forKey: Constant.userDefaultKey.isUserLoggedIn))
      }
    func testMarkUserLoggedOut() {
        sut?.markUserLoggedOut()
        XCTAssertFalse(UserDefaults.standard.bool(forKey: Constant.userDefaultKey.isUserLoggedIn))
    }
    
    func testIsUserLoggedInTrue() {
        sut?.userDefaults.setValue(true, forKey: Constant.userDefaultKey.isUserLoggedIn)
        XCTAssertTrue(sut?.isUserLoggedIn() ?? false)
    }
    func testIsUserLoggedInFalse() {
        sut?.userDefaults.setValue(false, forKey: Constant.userDefaultKey.isUserLoggedIn)
        XCTAssertFalse(sut?.isUserLoggedIn() ?? true)
    }
}
