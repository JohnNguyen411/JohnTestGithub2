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
    
    override func setUp() {
        super.setUp()
        
        flowViewController = FTUEViewController()
        _ = flowViewController?.view // call viewDidLoad
        
        XCTAssertNotNil(flowViewController?.view)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        flowViewController = nil
        super.tearDown()
    }
    

    func testFTUEFlow() {
        XCTAssertTrue(internalTestNumberItems())
        XCTAssertTrue(internalTestLoginView())
        XCTAssertTrue(internalTestPhoneNumberView())
    }
    
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
        let controllerAtIndex = flowViewController.controllerAtIndex(index: currentPosition) as! FTUELoginViewController
        
        // Check controller match the view
        XCTAssertTrue(viewAtIndex == controllerAtIndex.view)
        
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
        
        return true
    }
    
}
