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
    
    var flowViewController: FTUEViewController?
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        
        app.launchArguments = ["reset", "testMode"]
        app.launch()
        
        flowViewController = FTUEViewController()
        _ = flowViewController?.view // call viewDidLoad
        
        XCTAssertNotNil(flowViewController?.view)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDown() {
        flowViewController = nil
        super.tearDown()
    }
    
/*
    func testFTUEFlow() {
        XCTAssertTrue(internalTestNumberItems())
        XCTAssertTrue(internalTestLoginView())
        XCTAssertTrue(internalTestPhoneNumberView())
        XCTAssertTrue(internalTestPhoneNumberVerificationView())
        XCTAssertTrue(internalTestAllSetScreen())
    }
 
 */
    func internalTestNumberItems() -> Bool {
        XCTAssertTrue(flowViewController?.numberOfItems(viewPager: (flowViewController?.viewPager)!) == FTUEViewController.nbOfItems)
        return true
    }
    
    func internalTestLoginView() -> Bool {
        
        guard let flowViewController = flowViewController else {
            return false
        }
        
        XCTAssertTrue(flowViewController.viewPager.currentPosition == 0)
        flowViewController.pressButton(button: flowViewController.nextButton)
        let currentPosition = flowViewController.viewPager.currentPosition - 1
        XCTAssertTrue(currentPosition == 1)
        
        let viewAtIndex = flowViewController.viewAtIndex(viewPager: flowViewController.viewPager, index: currentPosition, view: nil)
        let controllerAtIndex = flowViewController.controllerAtIndex(index: currentPosition) as! FTUEChildViewController
        
        // Check controller match the view
        XCTAssertTrue(viewAtIndex == controllerAtIndex.view)
        
        // skip as it's a webview
        /*
        // Check textfields exists
        let app = XCUIApplication()
        let volvoIdView = app.windows.element(matching: .any, identifier: "volvoIdTextField")
        let volvoPwdView = app.windows.element(matching: .any, identifier: "volvoPwdTextField")
        let volvoVINView = app.windows.element(matching: .any, identifier: "volvoVINTextField")
        
        XCTAssertNotNil(volvoIdView)
        XCTAssertNotNil(volvoPwdView)
        XCTAssertNotNil(volvoVINView)
        
        // check that next button isn't enable when data empty

        let volvoIdTextField = controllerAtIndex.volvoIdTextField
        let volvoPwdTextField = controllerAtIndex.volvoPwdTextField
        let volvoVINTextField = controllerAtIndex.volvoVINTextField
        
        XCTAssertTrue(volvoIdTextField.textField.text!.isEmpty)
        XCTAssertTrue(volvoPwdTextField.textField.text!.isEmpty)
        XCTAssertTrue(volvoVINTextField.textField.text!.isEmpty)
        
        XCTAssertFalse(flowViewController.nextButton.isEnabled)
        
        // fill with fake data
        volvoIdTextField.textField.text = "johan.giroux@volvocars.com"
        volvoPwdTextField.textField.text = "QWERTYUIOP"
        volvoVINTextField.textField.text = "123AQW123QWE123ASD"
        
        // fire validation method manually
        controllerAtIndex.checkTextFieldsValidity()
        
        // check that next button is enable when data
        XCTAssertTrue(flowViewController.nextButton.isEnabled)
         */
        
        // go to next screen
        flowViewController.pressButton(button: flowViewController.nextButton)
        
        return true

    }
    
    func internalTestPhoneNumberView() -> Bool{
        guard let flowViewController = flowViewController else {
            return false
        }
        
        let currentPosition = flowViewController.viewPager.currentPosition - 1
        
        XCTAssertTrue(currentPosition == 2)
        
        let viewAtIndex = flowViewController.viewAtIndex(viewPager: flowViewController.viewPager, index: currentPosition, view: nil)
        let controllerAtIndex = flowViewController.controllerAtIndex(index: currentPosition) as! FTUEPhoneNumberViewController
        
        // Check controller match the view
        XCTAssertTrue(viewAtIndex == controllerAtIndex.view)
        
        // Check textfields exists
        let app = XCUIApplication()
        let phoneNumberView = app.windows.element(matching: .any, identifier: "phoneNumberTextField")
        
        XCTAssertNotNil(phoneNumberView)
        
        let phoneNumberTextField = controllerAtIndex.phoneNumberTextField

        XCTAssertTrue(phoneNumberTextField.textField.text!.isEmpty)
        XCTAssertFalse(flowViewController.nextButton.isEnabled)
        
        // fill with fake data
        phoneNumberTextField.textField.text = "5555555555"
        
        // fire validation method manually
        controllerAtIndex.checkTextFieldsValidity()
        
        // check that next button is enable when data
        XCTAssertTrue(flowViewController.nextButton.isEnabled)
        
        // go to next screen
        flowViewController.pressButton(button: flowViewController.nextButton)

        return true
    }
    
    func internalTestPhoneNumberVerificationView() -> Bool {
        guard let flowViewController = flowViewController else {
            return false
        }
        
        let currentPosition = flowViewController.viewPager.currentPosition - 1
        
        XCTAssertTrue(currentPosition == 3)
        
        let viewAtIndex = flowViewController.viewAtIndex(viewPager: flowViewController.viewPager, index: currentPosition, view: nil)
        let controllerAtIndex = flowViewController.controllerAtIndex(index: currentPosition) as! FTUEPhoneVerificationViewController
        
        // Check controller match the view
        XCTAssertTrue(viewAtIndex == controllerAtIndex.view)
        
        // Check textfields exists
        let app = XCUIApplication()
        let phoneNumberView = app.windows.element(matching: .any, identifier: "codeTextField")
        
        XCTAssertNotNil(phoneNumberView)
        
        let codeTextField = controllerAtIndex.codeTextField
        
        XCTAssertTrue(codeTextField.textField.text!.isEmpty)
        XCTAssertFalse(flowViewController.nextButton.isEnabled)
        
        // fill with fake data
        codeTextField.textField.text = "0000"
        
        // fire validation method manually
        controllerAtIndex.checkTextFieldsValidity()
        
        // check that next button is enable when data
        XCTAssertTrue(flowViewController.nextButton.isEnabled)
        
        // go to next screen
        flowViewController.pressButton(button: flowViewController.nextButton)
        
        return true
    }
    
    func internalTestAllSetScreen() -> Bool {
        guard let flowViewController = flowViewController else {
            return false
        }
        
        let currentPosition = flowViewController.viewPager.currentPosition - 1
        
        XCTAssertTrue(currentPosition == 4)
        
        let viewAtIndex = flowViewController.viewAtIndex(viewPager: flowViewController.viewPager, index: currentPosition, view: nil)
        let controllerAtIndex = flowViewController.controllerAtIndex(index: currentPosition) as! FTUEAllSetViewController
        
        // Check controller match the view
        XCTAssertTrue(viewAtIndex == controllerAtIndex.view)
        
        // Check textfields exists
        let app = XCUIApplication()
        let allSetLabelView = app.windows.element(matching: .any, identifier: "allSetLabel")
        
        XCTAssertNotNil(allSetLabelView)
        
        // check that next button is enable when data
        XCTAssertTrue(flowViewController.nextButton.isEnabled)
        
        // go to next screen
        flowViewController.pressButton(button: flowViewController.nextButton)

        return true
    }

}
