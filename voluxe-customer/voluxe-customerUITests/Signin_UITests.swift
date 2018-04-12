//
//  Signin_UITests.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/12/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

class Signin_UITests: XCTestCase {
    
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
    
    func testLogin() {
        
        let app = app2
        app.buttons["SIGN-IN"].tap()
        
        let app2 = app
        app2/*@START_MENU_TOKEN@*/.textFields["name@domain.com"]/*[[".otherElements[\"volvoIdTextField\"].textFields[\"name@domain.com\"]",".textFields[\"name@domain.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("johan@luxe.com")
        
        let secureTextField = app2/*@START_MENU_TOKEN@*/.secureTextFields["••••••••"]/*[[".otherElements[\"volvoPwdTextField\"].secureTextFields[\"••••••••\"]",".secureTextFields[\"••••••••\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        secureTextField.tap()
        secureTextField.typeText("Ch@ngeth1s")
        app.navigationBars["voluxe_customer.FTUELoginView"].buttons["Next"].tap()
        
        
    }
    
}
