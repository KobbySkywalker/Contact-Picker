//
//  Chango_v2UITests.swift
//  Chango v2UITests
//
//  Created by Hosny Ben Savage on 08/10/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import XCTest

class Chango_v2UITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testOnboarding() {
        
        app.tap()
        
        app.buttons["Login"].tap()
    }
    
    func testLoginFail() {
                                
        let emailField = app.textFields["Email"]
        emailField.tap()
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("Clock12")
        
        app.buttons["LOGIN"].tap()
        XCTAssertEqual(app.buttons["LOGIN"].exists, true)
        
        sleep(5)

        _ = addUIInterruptionMonitor(withDescription: "Invalid Credentials.") { (alert: XCUIElement) -> Bool in
            self.app.buttons["Okay"].tap()

            return true
            }
        
        }
    
    
    func testLoginEmptyPassword() {
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        
        app.buttons["LOGIN"].tap()
    }
    
    
    func testLoginSuccess() {
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("Clock1234")
        
        app.buttons["LOGIN"].tap()
    }

    
    func testSignUpFail() {
        
        app.buttons["Sign up"].tap()
        
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("mamuzu@itconsortiumgh.com")
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("Clock1234")
        
        let confirmPasswordField = app.secureTextFields["Password"]
        confirmPasswordField.tap()
        confirmPasswordField.typeText("Clock1234")
        
        app.buttons["SIGN UP"].tap()
    }
    
    
    func testSignUpSuccess() {
        
        app.buttons["Sign up"].tap()
        
        let emailField = app.textFields.textFields["Email"]
        app.textFields.matching(identifier: "Email")
        emailField.tap()
        emailField.typeText("mamuzu@itconsortiumgh.com")
        
        let newPasswordField = app.textFields["Password"]
        newPasswordField.tap()
        newPasswordField.typeText("Clock1234")
        
        let confirmPasswordFIeld = app.textFields["Confirm password"]
        confirmPasswordFIeld.tap()
        confirmPasswordFIeld.typeText("Clock1234")
        
        app.buttons["SIGN UP"].tap()

    }
    
    
    func testSignUpEmptyField() {
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        
        let newPasswordTextField = app.textFields["Password"]
        newPasswordTextField.tap()
        newPasswordTextField.typeText("Clock1234")
        
        let confirmPasswordTextFIeld = app.textFields["Confirm password"]
        confirmPasswordTextFIeld.tap()
        confirmPasswordTextFIeld.typeText("Clock123")
        
        app.buttons["SIGN UP"].tap()
    }
}
