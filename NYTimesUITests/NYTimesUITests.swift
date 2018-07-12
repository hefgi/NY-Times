//
//  NYTimesUITests.swift
//  NYTimesUITests
//
//  Created by François-Julien Alcaraz on 10/07/2018.
//  Copyright © 2018 Mokriya. All rights reserved.
//

import XCTest

// Got inspired with https://github.com/joemasilotti/UI-Testing-Cheat-Sheet

class NYTimesUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPushDetailViewController() {
        let app = XCUIApplication()
        var listTableView = app.tables["ListTableView"]
        
        // Let's wait to get the data
        wait(for: 5.0)
        
        // Should not be empty
        XCTAssertGreaterThan(listTableView.cells.count, 0)
        
        let cell = listTableView.cells.containing(.cell, identifier: "0")
        let cellTitleLabel = cell.staticTexts["TitleLabel"].label
        let cellAuthorsLabel = cell.staticTexts["AuthorsLabel"].label
        let cellDateLabel = cell.staticTexts["DateLabel"].label

        // should not be equal to default value
        XCTAssertNotEqual(cellTitleLabel, "Label")
        XCTAssertNotEqual(cellAuthorsLabel, "Label")
        XCTAssertNotEqual(cellDateLabel, "Label")

        // Show detail VC
        cell.staticTexts.element(boundBy: 0).tap()
        
        let detailTitleLabel = app.staticTexts["TitleLabel"].label
        let detailAuthorLabel = app.staticTexts["AuthorsLabel"].label
        let detailDateLabel = app.staticTexts["DateLabel"].label
        let detailDescriptionTextView = app.textViews["DescriptionTextView"]

        // Data should be equal to cell Data
        XCTAssertEqual(detailTitleLabel, cellTitleLabel)
        XCTAssertEqual(detailAuthorLabel, cellAuthorsLabel)
        XCTAssertEqual(detailDateLabel, cellDateLabel)

        // TextView should not be empty
        if
            let string = detailDescriptionTextView.value as? String,
            string.count == 0 {
            XCTFail()
        }
        
        // Get back to main
        XCUIApplication().navigationBars["Detail"].buttons["Back"].tap()
        
        listTableView = app.tables["ListTableView"]

        // check if tableview is here
        XCTAssertTrue(listTableView.exists)
    }
}

private extension XCTestCase {
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}
