//
//  FTUEFlow_UITests.swift
//  voluxe-customerUITests
//
//  Created by Giroux, Johan on 11/22/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

class FTUEFlow_UITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        
        app.launchArguments = ["reset", "testMode"]
        app.launch()
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSignup() {
        
        app.buttons["CREATE ACCOUNT"].tap()
        
        app/*@START_MENU_TOKEN@*/.textFields["Johan"]/*[[".otherElements[\"firstNameTextField\"].textFields[\"Johan\"]",".textFields[\"Johan\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("Johan")
        
        let johanssonTextField = app/*@START_MENU_TOKEN@*/.textFields["Johansson"]/*[[".otherElements[\"lastNameTextField\"].textFields[\"Johansson\"]",".textFields[\"Johansson\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        johanssonTextField.tap()
        johanssonTextField.typeText("Johansson")
        
        let doneButton = app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        
        let nameDomainComTextField = app/*@START_MENU_TOKEN@*/.textFields["name@domain.com"]/*[[".otherElements[\"emailTextField\"].textFields[\"name@domain.com\"]",".textFields[\"name@domain.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nameDomainComTextField.typeText("\n")
        nameDomainComTextField.tap()
        nameDomainComTextField.typeText("Johan+22@luxe.com")
        
        let textField = app/*@START_MENU_TOKEN@*/.textFields["(555) 555-5555"]/*[[".otherElements[\"phoneNumberTextField\"].textFields[\"(555) 555-5555\"]",".textFields[\"(555) 555-5555\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        textField.tap()
        textField.typeText("55555555555555")
        
        let nextButton = app.navigationBars["voluxe_customer.FTUESignupEmailPhoneView"].buttons["Next"]
        nextButton.tap()

        let textField2 = app/*@START_MENU_TOKEN@*/.textFields["0000"]/*[[".otherElements[\"codeTextField\"].textFields[\"0000\"]",".textFields[\"0000\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        textField2.tap()
        textField2.typeText("0000")
        app.navigationBars["voluxe_customer.FTUEPhoneVerificationView"].buttons["Next"].tap()
        
        let secureTextField = app.otherElements["volvoPwdTextField"].secureTextFields["••••••••"]
        secureTextField.tap()
        secureTextField.typeText("toto1234")
        
        let secureTextField2 = app.otherElements["volvoPwdConfirmTextField"].secureTextFields["••••••••"]
        secureTextField2.tap()
        secureTextField2.tap()
        secureTextField2.typeText("toto1234")
        doneButton/*@START_MENU_TOKEN@*/.press(forDuration: 0.7);/*[[".tap()",".press(forDuration: 0.7);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    }
    
}
