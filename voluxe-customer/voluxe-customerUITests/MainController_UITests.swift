//
//  MainController_UITests.swift
//  voluxe-customerUITests
//
//  Created by Giroux, Johan on 11/28/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import XCTest

class MainController_UITests: XCTestCase {
    
    var mainViewController: MainViewController?
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
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
    
    func testStates() {
        // check state is Idle
        XCTAssertTrue(StateServiceManager.sharedInstance.getState() == ServiceState.idle || StateServiceManager.sharedInstance.getState() == ServiceState.needService)
        XCTAssertNotNil(mainViewController?.currentViewController)
        XCTAssertTrue(mainViewController!.currentViewController!.isKind(of: SchedulingPickupViewController.self))
        
        // check if the dealershipView is here
        let dealershipView = app.otherElements["dealershipView"]
        XCTAssertTrue(dealershipView.exists)
        
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
        
        // go to next
        bottomButton = app.buttons["bottomButton"]
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
        
        // go to next
        bottomButton = app.buttons["bottomButton"]
        XCTAssertTrue(bottomButton.exists)
        bottomButton.tap()
        
        sleep(1)

        print(app.debugDescription)
        
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
