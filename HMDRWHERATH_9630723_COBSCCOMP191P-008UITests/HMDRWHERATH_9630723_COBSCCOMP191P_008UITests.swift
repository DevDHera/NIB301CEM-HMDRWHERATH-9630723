//
//  HMDRWHERATH_9630723_COBSCCOMP191P_008UITests.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008UITests
//
//  Created by user180410 on 9/20/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import XCTest

class HMDRWHERATH_9630723_COBSCCOMP191P_008UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
    
    func testValidLoginSuccess() {
        let validPassword = "123456"
        let validEmail = "test001@gmail.com"
        
        XCUIApplication().activate()
        let app = XCUIApplication()
        app.tabBars.buttons["Update"].tap()
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(validEmail)
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(validPassword)
        
        app.buttons["Sign In"].tap()
        
        let surveyView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0)
        XCTAssertTrue(surveyView.exists)
        
    }
    
    func testInValidLoginAlertShow() {
        let validPassword = "12345678"
        let validEmail = "test001@gmail.comhh"
        
        XCUIApplication().activate()
        let app = XCUIApplication()
        app.tabBars.buttons["Update"].tap()
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(validEmail)
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(validPassword)
        
        app.buttons["Sign In"].tap()
        
        let alertView = app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements[\"SCLAlertView\"].buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(alertView.exists)
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
