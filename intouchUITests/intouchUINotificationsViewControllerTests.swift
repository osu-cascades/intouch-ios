//
//  intouchUINotificationsViewControllerTests.swift
//  intouchUITests
//

import XCTest
@testable import intouch

class intouchUINotificationsViewControllerTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        
        // login in
        let loginVc: LoginVC = LoginVC()
        loginVc.onLoginSuccess(username: "client", password: "password", userType: "client")

    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testExample() {
        
    }
    
}
