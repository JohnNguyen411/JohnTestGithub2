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

    override func setUp() {
        super.setUp()
        
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
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
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
        
        // change state to Volvo Pickup
        StateServiceManager.sharedInstance.updateState(state: ServiceState.pickupScheduled)
        XCTAssertNotNil(mainViewController?.currentViewController)
        XCTAssertTrue(mainViewController!.currentViewController!.isKind(of: ScheduledPickupViewController.self))
        
        // this will always timeout
        let predicate = NSPredicate(format: "rawValue == \(ServiceState.pickupDriverInRoute.rawValue)")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: StateServiceManager.sharedInstance.getState())
        
        // don't check result as it's timeout
        let result = XCTWaiter().wait(for: [expectation], timeout: 10)
        
        // check state
        XCTAssertTrue(StateServiceManager.sharedInstance.getState() == ServiceState.pickupDriverInRoute)
        
    }
    
}
