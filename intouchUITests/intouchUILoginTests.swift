//
//  intouchUITests.swift
//  intouchUITests
//
//

import XCTest
@testable import intouch

class intouchUILoginTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidLoginCredentialsLoadsTabView() {
        
        app.textFields["username"].tap()
        
        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cKey.tap()
        let lKey = app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        lKey.tap()
        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()
        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        // enter client's password
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        cKey.tap()
        lKey.tap()
        iKey.tap()
        eKey.tap()
        nKey.tap()
        tKey.tap()
        
        let pKey = app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pKey.tap()
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        sKey.tap()
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        sleep(2)
        XCTAssert(app.navigationBars["Notifications"].otherElements["Notifications"].exists)
        
        XCUIDevice.shared.orientation = .portrait
        
        app.navigationBars["Notifications"].buttons["Logout"].tap()
        app.alerts["Alert"].buttons["Yes"].tap()
        
        XCTAssert(app.textFields["username"].exists)

        XCUIDevice.shared.orientation = .faceUp
        
    }
    
    func testInvalidCredentialsAtLoginThrowsAlert() {
        
        app.textFields["username"].tap()
        
        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cKey.tap()
        
        // enter invalid credentials
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()

        let pKey = app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pKey.tap()

        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        sleep(2)
        
        XCTAssert(app.alerts.element.staticTexts["Username and/or password is invalid."].exists)
        
        app.alerts["Alert"].buttons["OK"].tap()
        
    }
    
    func testBlankUsernameAndPasswordThrowsAlert() {
        XCUIDevice.shared.orientation = .faceUp
        XCUIDevice.shared.orientation = .portrait
        
        app.buttons["Login"].tap()
        
        XCTAssert(app.alerts.element.staticTexts["Username and Password cannot be blank."].exists)
    
        app.alerts["Alert"].buttons["OK"].tap()
        
        XCTAssert(app.textFields["username"].exists)
        XCTAssert(app.secureTextFields["password"].exists)
        
    }
    
    func testBlankUsernameThrowsAlert() {
        XCUIDevice.shared.orientation = .faceUp
        XCUIDevice.shared.orientation = .portrait
        
        app.secureTextFields["password"].tap()
        app.keys["p"].tap()
        app.keys["a"].tap()
        app.keys["s"].tap()
        app.keys["s"].tap()
        app.keys["w"].tap()
        app.keys["o"].tap()
        app.keys["r"].tap()
        app.keys["d"].tap()
        
        app.buttons["Login"].tap()
        
        XCTAssert(app.alerts.element.staticTexts["Username and Password cannot be blank."].exists)
        
        app.alerts["Alert"].buttons["OK"].tap()
        
        XCTAssert(app.textFields["username"].exists)
        XCTAssert(app.secureTextFields["password"].exists)
    }
    
    func testBlankPasswordThrowsAlert() {
        XCUIDevice.shared.orientation = .faceUp
        XCUIDevice.shared.orientation = .portrait
        
        app.textFields["username"].tap()
        app.keys["u"].tap()
        app.keys["s"].tap()
        app.keys["e"].tap()
        app.keys["r"].tap()
        app.keys["n"].tap()
        app.keys["a"].tap()
        app.keys["m"].tap()
        app.keys["e"].tap()
        
        app.buttons["Login"].tap()
        
        XCTAssert(app.alerts.element.staticTexts["Username and Password cannot be blank."].exists)
        
        app.alerts["Alert"].buttons["OK"].tap()
        
        XCTAssert(app.textFields["username"].exists)
        XCTAssert(app.secureTextFields["password"].exists)
    }
    
}
