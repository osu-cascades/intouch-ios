//
//  CreateNotificationViewControllerTests.swift
//  intouchUITests
//


import XCTest
@testable import intouch

class CreateNotificationViewControllerTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
       
        app = XCUIApplication()
        app.launch()
        
        // login in
        app.textFields["username"].tap()
        app.textFields["username"].typeText("client")
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("clientpass")
        app.buttons["Login"].tap()
        
        // go to create notification view controller
        app.tabBars.buttons["Create"].tap()

    }
    
    override func tearDown() {
        // go to notificatins view controller
        app.tabBars.buttons["View"].tap()
        
        // log out
        app.navigationBars["Notifications"].buttons["Logout"].tap()
        app.alerts["Alert"].buttons["Yes"].tap()
        super.tearDown()
    }
    
    func testUserCanSendValidNotification() {

        // fill out title text field
        app.textFields["createTitle"].tap()
        app.textFields["createTitle"].typeText("iphone test title")
        
        // set group to send notification to
        //app.pickers["toPicker"].tap()
        //app.pickers["toPicker"].adjust(toPickerWheelValue: "Journey")

        // fill out message text view
        app.textViews["createMessage"].tap()
        app.textViews["createMessage"].typeText("iphone test message")
        app.staticTexts["Title:"].tap()
        
        // send notification
        app.buttons["sendBtn"].tap()
     
        // verify message sent
        XCTAssert(app.alerts.element.staticTexts["Notification successfully sent."].exists)
        app.alerts["Status"].buttons["OK"].tap()
        
    }
    
    func testUserCannotLeaveTitleOrMessageBlank() {
        
        // leave both text fields blank
        app.buttons["sendBtn"].tap()
        
        // assert
        XCTAssert(app.alerts.element.staticTexts["Title and message cannot be blank."].exists)
        
        // dismiss
        app.alerts["Alert"].buttons["OK"].tap()
        
        // leave message text view blank
        app.textFields["createTitle"].tap()
        app.textFields["createTitle"].typeText("iphone test title")
        
        // dismiss keyboard
        app.staticTexts["Title:"].tap()
        
        app.buttons["sendBtn"].tap()
        
        // assert
        XCTAssert(app.alerts.element.staticTexts["Title and message cannot be blank."].exists)
        
        // dismiss
        app.alerts["Alert"].buttons["OK"].tap()
        
        // leave title text field blank
        app.textFields["createTitle"].tap()
        for _ in 1...17 {
            app.keys["delete"].tap()
        }
        
        app.textViews["createMessage"].tap()
        app.textViews["createMessage"].typeText("iphone test message")
        
        // dismiss keyboard
        app.staticTexts["Title:"].tap()
        
        app.buttons["sendBtn"].tap()
        
        // assert
        XCTAssert(app.alerts.element.staticTexts["Title and message cannot be blank."].exists)
        
        // dismiss
        app.alerts["Alert"].buttons["OK"].tap()
        
    }
    
    func testTest() {
        
    }
    
}
