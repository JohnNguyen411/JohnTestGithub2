//
//  MainController_UITests.swift
//  voluxe-customerUITests
//
//  Created by Giroux, Johan on 11/28/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import XCTest
@testable import voluxe_customer

class MainController_UITests: XCTestCase {
    
    var mainViewController: MainViewController?
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()

        app.launchArguments = ["testMode"]
        app.launch()
        
        // Init GMSServices
        let testBundle = Bundle(for: type(of: self))
        let mapApiKey = testBundle.object(forInfoDictionaryKey: "GoogleMapsAPIKey")
        XCTAssertNotNil(mapApiKey)
        GMSServices.provideAPIKey(mapApiKey as! String)
        
        mainViewController = MainViewController()
        _ = mainViewController?.view // call viewDidLoad
        StateServiceManager.sharedInstance.addDelegate(delegate: mainViewController!)
        
        XCTAssertNotNil(mainViewController?.view)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDown() {
        StateServiceManager.sharedInstance.removeDelegate(delegate: mainViewController!)
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFTUE() {
        
        let nextButtonButton = app.buttons["next button"]
        nextButtonButton.tap()
        sleep(1)
        
        let elementsQuery = app.scrollViews.otherElements
        let webViewsQuery = elementsQuery.webViews
        let element = webViewsQuery.otherElements["Volvo Auth Mock"].children(matching: .other).element
        let textField = element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element
        _ = waitForElementToAppear(textField, timeout: 5)
        textField.tap()
        
        sleep(1)

        textField.typeText("test@test.com")
        
        let secureTextField = element.children(matching: .other).element(boundBy: 1).children(matching: .secureTextField).element
        _ = waitForElementToAppear(secureTextField, timeout: 5)

        secureTextField.tap()

        sleep(1)

        secureTextField.typeText("toto123")
        webViewsQuery/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements[\"Volvo Auth Mock\"].buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        let allowButton = webViewsQuery/*@START_MENU_TOKEN@*/.buttons["Allow"]/*[[".otherElements[\"Volvo Auth Mock\"].buttons[\"Allow\"]",".buttons[\"Allow\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        _ = waitForElementToAppear(allowButton, timeout: 5)
        
        sleep(1)

        allowButton.tap()
        
        sleep(5)
        
        elementsQuery/*@START_MENU_TOKEN@*/.textFields["(555) 555-5555"]/*[[".otherElements[\"phoneNumberTextField\"].textFields[\"(555) 555-5555\"]",".textFields[\"(555) 555-5555\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("5555555555")
        nextButtonButton.tap()
        
        sleep(1)
        
        elementsQuery/*@START_MENU_TOKEN@*/.textFields["0000"]/*[[".otherElements[\"codeTextField\"].textFields[\"0000\"]",".textFields[\"0000\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("5555")
        
        sleep(1)
        nextButtonButton.tap()
        sleep(1)
        nextButtonButton.tap()
        sleep(1)
    }
    
    func testPickupDelivery() {
        internalTestSchedulePickup()
        internalTestPickup()
        internalTestDrivingToDealership()
        internalTestServicing()
        internalTestScheduleDropoff()
        internalTestDropOff()
    }
    
    func internalTestSchedulePickup() {
        sleep(3) // wait for the app to call customer / cars enpoint

        // check if the dealershipView is here
        let dealershipView = app.otherElements["dealershipView"]
        XCTAssertTrue(dealershipView.exists)
        
        let dealershipTestView = app.otherElements["dealershipTestView"]
        _ = waitForElementToAppear(dealershipTestView, timeout: 5)
        XCTAssertTrue(dealershipTestView.exists)
        
        //  and tap on it
        dealershipView.tap()
        sleep(1)
        
        // check that dealershipModal is showing
        let dealershipModal = app.otherElements["dealershipVC"]
        XCTAssertTrue(dealershipModal.exists)
        
        let groupedLabelOne = app.otherElements["groupedLabel1"]
        XCTAssertTrue(groupedLabelOne.exists)
        sleep(1)
        
        var bottomButton = app.buttons["bottomButton"]
        XCTAssertTrue(bottomButton.exists)
        bottomButton.tap()
        
        sleep(1)

        let rightButton = app.buttons["rightButton"]
        XCTAssertTrue(rightButton.exists)
        rightButton.tap()
        sleep(1)

        // show CalendarView
        let dateModal = app.otherElements["dateModal"]
        XCTAssertTrue(dateModal.exists)
        
        let handler = addUIInterruptionMonitor(withDescription: "Location Dialog") { (alert) -> Bool in
            let button = alert.buttons["Allow"]
            if button.exists {
                button.tap()
                return true
            }
            return false
        }
        
        // go to next
        bottomButton = app.buttons["bottomButton"]
        XCTAssertTrue(bottomButton.exists)
        bottomButton.tap()
        
        app.tap()

        sleep(1)
        
        // show LocationView
        let locationVC = app.otherElements["locationVC"]
        XCTAssertTrue(locationVC.exists)
        
        removeUIInterruptionMonitor(handler)
        
        // enter new Location
        let locationTextField = app.textFields["newLocationTextField.textField"]
        XCTAssertTrue(locationTextField.exists)
        locationTextField.tap()
        sleep(1)
        locationTextField.typeText("535 Mission St, San Francisco, CA")
        
        sleep(1)
        
        let locationAddButton = app.staticTexts["newLocationTextField.rightLabel"]
        XCTAssertTrue(locationAddButton.exists)
        locationAddButton.tap()
        
        sleep(1)

        // go to next
        bottomButton = app.buttons["bottomButton"]
        XCTAssertTrue(bottomButton.exists)
        
        bottomButton.tap()
        
        sleep(1)
        
        let loanerVC = app.otherElements["loanerVC"]
        XCTAssertTrue(loanerVC.exists)

        bottomButton.tap()
        
        sleep(1)

        // confirm reservation
        let confirmButton = app.buttons["confirmButton"]
        XCTAssertTrue(confirmButton.exists)
        confirmButton.tap()
        
        sleep(1)
    }
    
    func internalTestPickup() {
        let testElement = app.otherElements["testView"]
        let appeared = waitForElementToAppear(testElement, timeout: 10)
        XCTAssertTrue(appeared)
        
        let stepview0 = app.otherElements["stepview0"]
        let stepview0Appeared = waitForElementToAppear(stepview0, timeout: 5)
        XCTAssertTrue(stepview0Appeared)
        
        let stepview1 = app.otherElements["stepview1"]
        let stepview1Appeared = waitForElementToAppear(stepview1, timeout: 10)
        XCTAssertTrue(stepview1Appeared)
        
        let stepview2 = app.otherElements["stepview2"]
        let stepview2Appeared = waitForElementToAppear(stepview2, timeout: 50)
        XCTAssertTrue(stepview2Appeared)
        
        let stepview3 = app.otherElements["stepview3"]
        let stepview3Appeared = waitForElementToAppear(stepview3, timeout: 20)
        XCTAssertTrue(stepview3Appeared)
        
        sleep(1)
    }
    
    
    func internalTestDrivingToDealership() {
        
        let drivingToDealership = app.staticTexts["schedulingTestView\(ServiceState.pickupDriverDrivingToDealership)"]
        let drivingToDealershipAppeared = waitForElementToAppear(drivingToDealership, timeout: 20)
        XCTAssertTrue(drivingToDealershipAppeared)
        
        /*
        let driverAtDealership = app.staticTexts["schedulingTestView\(ServiceState.pickupDriverAtDealership)"]
        let driverAtDealershipAppeared = waitForElementToAppear(driverAtDealership, timeout: 20)
        XCTAssertTrue(driverAtDealershipAppeared)
        */
        
        let volvoPickupAlert = app.alerts["Volvo Pickup"]
        let alertAppeared = waitForElementToAppear(volvoPickupAlert, timeout: 20)
        XCTAssertTrue(alertAppeared)
        let alertHandler = addUIInterruptionMonitor(withDescription: "Volvo Pickup") {
            element in
            do {
                let button = element.buttons["okAction_AID"]
                if button.exists {
                    button.tap()
                }
            }
            return true
        }
        
        app.tap()
        removeUIInterruptionMonitor(alertHandler)
    }
    
    func internalTestServicing() {
        
        let servicing = app.staticTexts["schedulingTestView\(ServiceState.servicing)"]
        let servicingAppeared = waitForElementToAppear(servicing, timeout: 20)
        XCTAssertTrue(servicingAppeared)
        
        // check if the dealershipView is here
        let dealershipView = app.otherElements["dealershipView"]
        XCTAssertTrue(dealershipView.exists)
        
        // make sure confirm button not here
        var rightButton = app.buttons["rightButton"]
        XCTAssertFalse(rightButton.exists)
        
        sleep(1)
        
        let serviceCompleted = app.staticTexts["schedulingTestView\(ServiceState.serviceCompleted)"]
        let servicedAppeared = waitForElementToAppear(serviceCompleted, timeout: 20)
        XCTAssertTrue(servicedAppeared)
        
        sleep(1)
        
        // make sure Volvo Delivery button appeared
        rightButton = app.buttons["rightButton"]
        XCTAssertTrue(rightButton.exists)
        rightButton.tap()
        
        sleep(1)
    }
    
    func internalTestScheduleDropoff() {
        
        // show CalendarView
        let dateModal = app.otherElements["dateModal"]
        XCTAssertTrue(dateModal.exists)
        
        // go to next
        var bottomButton = app.buttons["bottomButton"]
        XCTAssertTrue(bottomButton.exists)
        bottomButton.tap()
        
        sleep(1)
        
        // show LocationView
        let locationVC = app.otherElements["locationVC"]
        XCTAssertTrue(locationVC.exists)
        
        // enter new Location
        let locationTextField = app.textFields["newLocationTextField.textField"]
        XCTAssertTrue(locationTextField.exists)
        locationTextField.tap()
        sleep(1)
        locationTextField.typeText("535 Mission St, San Francisco, CA")
        
        sleep(1)
        
        let locationAddButton = app.staticTexts["newLocationTextField.rightLabel"]
        XCTAssertTrue(locationAddButton.exists)
        locationAddButton.tap()
        
        sleep(1)
        
        // go to next
        bottomButton = app.buttons["bottomButton"]
        XCTAssertTrue(bottomButton.exists)
        
        bottomButton.tap()
        
        sleep(1)

        // confirm reservation
        let confirmButton = app.buttons["confirmButton"]
        
        XCTAssertTrue(confirmButton.exists)
        confirmButton.tap() // Test Fail here, try & take pic
        
        sleep(1)
        
    }
    
    func internalTestDropOff() {
        
        /*
         case deliveryScheduled = 50
         case deliveryInRoute = 51
         case deliveryNearby = 52
         case deliveryArrived = 53
         */
        
        let testElement = app.otherElements["testView"]
        let appeared = waitForElementToAppear(testElement, timeout: 10)
        XCTAssertTrue(appeared)
        
        let stepview0 = app.otherElements["stepview0"]
        let stepview0Appeared = waitForElementToAppear(stepview0, timeout: 5)
        XCTAssertTrue(stepview0Appeared)
        
        let stepview1 = app.otherElements["stepview1"]
        let stepview1Appeared = waitForElementToAppear(stepview1, timeout: 20)
        XCTAssertTrue(stepview1Appeared)
        
        let stepview2 = app.otherElements["stepview2"]
        let stepview2Appeared = waitForElementToAppear(stepview2, timeout: 50)
        XCTAssertTrue(stepview2Appeared)
        
        let stepview3 = app.otherElements["stepview3"]
        let stepview3Appeared = waitForElementToAppear(stepview3, timeout: 20)
        XCTAssertTrue(stepview3Appeared)
        
        sleep(1)
    }
    
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expect = expectation(for: predicate, evaluatedWith: element,
                                      handler: nil)
        
        let result = XCTWaiter().wait(for: [expect], timeout: timeout)
        return result == .completed
    }
    
    func tapElementAndWaitForKeyboardToAppear(element: XCUIElement) {
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            element.tap()
            if keyboard.exists {
                break;
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
    }
    
    /*
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval) -> Bool {
        let expectation = XCTKVOExpectation(keyPath: "exists", object: element,
                                            expectedValue: true)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
 */
}
