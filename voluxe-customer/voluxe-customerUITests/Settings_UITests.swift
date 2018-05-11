//
//  Settings_UITests.swift
//  voluxe-customerUITests
//
//  Created by Giroux, Johan on 4/12/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

class Settings_UITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        
        app.launchArguments = ["reset", "testMode"]
        app.launch()
        
        // Init GMSServices
        let testBundle = Bundle(for: type(of: self))
        let mapApiKey = Config.sharedInstance.mapAPIKey()
        XCTAssertNotNil(mapApiKey)
        GMSServices.provideAPIKey(mapApiKey as! String)
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
        
    func testSettings() {
        
        internalTestLogin()
        sleep(3)

        app/*@START_MENU_TOKEN@*/.navigationBars["Your Volvos"]/*[[".otherElements[\"slideMenuController\"]",".otherElements[\"uiNavigationController\"].navigationBars[\"Your Volvos\"]",".navigationBars[\"Your Volvos\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.buttons["ic menu black 24dp"].tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Settings"]/*[[".otherElements[\"slideMenuController\"]",".otherElements[\"leftViewController\"].tables",".cells.staticTexts[\"Settings\"]",".staticTexts[\"Settings\"]",".tables"],[[[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["johan@luxe.com"]/*[[".otherElements[\"slideMenuController\"].tables",".cells.staticTexts[\"johan@luxe.com\"]",".staticTexts[\"johan@luxe.com\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["ADD A NEW LOCATION"]/*[[".otherElements[\"slideMenuController\"].tables",".cells.staticTexts[\"ADD A NEW LOCATION\"]",".staticTexts[\"ADD A NEW LOCATION\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
        let newlocationtextfieldTextfieldTextField = app/*@START_MENU_TOKEN@*/.textFields["newLocationTextField.textField"]/*[[".otherElements[\"locationVC\"]",".textFields[\"123 Main Street, San Francisco\"]",".textFields[\"newLocationTextField.textField\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        newlocationtextfieldTextfieldTextField.tap()
        newlocationtextfieldTextfieldTextField.typeText("535 Mission S")
        sleep(1)

        let tablesQuery = app.tables
        let cellQuery = tablesQuery.cells.containing(.staticText, identifier: "VLVerticalSearchTextField")
        let cell = cellQuery.children(matching: .staticText)
        let cellElement = cell.element
        cellElement.tap()
        sleep(10)

        //app/*@START_MENU_TOKEN@*/.staticTexts["Address for Pickup"]/*[[".otherElements[\"locationVC\"].staticTexts[\"Address for Pickup\"]",".staticTexts[\"Address for Pickup\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(1)
        app/*@START_MENU_TOKEN@*/.buttons["bottomButton"]/*[[".otherElements[\"locationVC\"]",".buttons[\"ADD\"]",".buttons[\"bottomButton\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(1)
        
        let yourAccountNavigationBar = app/*@START_MENU_TOKEN@*/.navigationBars["Your Account"]/*[[".otherElements[\"slideMenuController\"].navigationBars[\"Your Account\"]",".navigationBars[\"Your Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        yourAccountNavigationBar.buttons["Edit"].tap()
//        app/*@START_MENU_TOKEN@*/.tables/*[[".otherElements[\"slideMenuController\"].tables",".tables"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"535 Mission Street, San Francisco, CA 94105, USA").children(matching: .button).element.tap()
        sleep(1)
        
        
        yourAccountNavigationBar.buttons["Done"].tap()
        yourAccountNavigationBar.buttons["Back"].tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Grey 2018 XC90"]/*[[".otherElements[\"slideMenuController\"].tables",".cells.staticTexts[\"Grey 2018 XC90\"]",".staticTexts[\"Grey 2018 XC90\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.navigationBars["Grey 2018 XC90"]/*[[".otherElements[\"slideMenuController\"].navigationBars[\"Grey 2018 XC90\"]",".navigationBars[\"Grey 2018 XC90\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Back"].tap()
        app/*@START_MENU_TOKEN@*/.navigationBars["Settings"]/*[[".otherElements[\"slideMenuController\"].navigationBars[\"Settings\"]",".navigationBars[\"Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["ic menu black 24dp"].tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Your Volvos"]/*[[".otherElements[\"slideMenuController\"]",".otherElements[\"leftViewController\"].tables",".cells.staticTexts[\"Your Volvos\"]",".staticTexts[\"Your Volvos\"]",".tables"],[[[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    func internalTestLogin() {
        
        app.buttons["SIGN-IN"].tap()
        
        app/*@START_MENU_TOKEN@*/.textFields["name@domain.com"]/*[[".otherElements[\"volvoIdTextField\"].textFields[\"name@domain.com\"]",".textFields[\"name@domain.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("johan@luxe.com")
        
        let secureTextField = app/*@START_MENU_TOKEN@*/.secureTextFields["••••••••"]/*[[".otherElements[\"volvoPwdTextField\"].secureTextFields[\"••••••••\"]",".secureTextFields[\"••••••••\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        secureTextField.tap()
        secureTextField.typeText("Ch@ngeth1s")
        app.navigationBars["voluxe_customer.FTUELoginView"].buttons["Next"].tap()
        
        app = XCUIApplication()
        
        app.launchArguments = ["testMode"]
        app.launch()
        
    }
    
}
