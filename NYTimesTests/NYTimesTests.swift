//
//  NYTimesTests.swift
//  NYTimesTests
//
//  Created by François-Julien Alcaraz on 10/07/2018.
//  Copyright © 2018 Mokriya. All rights reserved.
//

import XCTest
@testable import NYTimes

class NYTimesTests: XCTestCase {
    var sessionUnderTest: URLSession!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetMostViewed() {
        let promise = expectation(description: "Get Most viewed Articles")
        var responseArticles: [Article]?
        NYTimesAPI.shared.getMostViewed { result in
            switch result {
            case .success(let articles):
                responseArticles = articles
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(responseArticles)
    }
}
