//
//  intouchTests.swift
//  intouchTests
//
//  Created by Aaron on 2/8/18.
//  Copyright © 2018 Aaron. All rights reserved.
//

import XCTest
@testable import intouch

class intouchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testUsernameStoredCorrectlyAfterLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVc: LoginVC = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginVC
        loginVc.onLoginSuccess(username: "client", password: "clientpass", userType: "client")
        let username = Settings.getUsername()
        XCTAssertEqual("client", username)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
