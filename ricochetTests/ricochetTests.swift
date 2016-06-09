//
//  ricochetTests.swift
//  ricochetTests
//
//  Created by Lloyd Rochester on 6/8/16.
//  Copyright © 2016 Lloyd Rochester. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import ricochet

class ricochetTests: XCTestCase {
    var theExpectation:XCTestExpectation?
    var url = "http://localhost/testjson.php"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPost() {
        theExpectation = expectationWithDescription("initialized")
        
        func myCallback(json: JSON?,data: NSData?, response: NSHTTPURLResponse?, error: NSError?) {
            theExpectation?.fulfill() // it will release our "timer"
            XCTAssertTrue(error == nil)
            XCTAssertTrue(response?.statusCode>199 && response?.statusCode<300)
        }
        
        Ricochet().post(url, json: nil).request(myCallback)
        waitForExpectationsWithTimeout(20, handler: { error in XCTAssertNil(error, "Timeout on url \(self.url)")})
    }
    
    func testGet() {
        theExpectation = expectationWithDescription("initialized")
        
        func myCallback(json: JSON?,data: NSData?, response: NSHTTPURLResponse?, error: NSError?) {
            theExpectation?.fulfill() // it will release our "timer"
            XCTAssertTrue(error == nil)
            XCTAssertTrue(response?.statusCode>199 && response?.statusCode<300)
        }
        
        Ricochet().get(url).request(myCallback)
        waitForExpectationsWithTimeout(20, handler: { error in XCTAssertNil(error, "Timeout on url \(self.url)")})
    }
    
    func testGetWithParms() {
        theExpectation = expectationWithDescription("initialized")
        
        func myCallback(json: JSON?,data: NSData?, response: NSHTTPURLResponse?, error: NSError?) {
            theExpectation?.fulfill() // it will release our "timer"
            XCTAssertTrue(error == nil)
            XCTAssertTrue(response?.statusCode>199 && response?.statusCode<300)
        }
        
        let q = ["a":"z","b":"y"]
        Ricochet().get(url, queryParms: q).request(myCallback)
        waitForExpectationsWithTimeout(20, handler: { error in XCTAssertNil(error, "Timeout on url \(self.url)")})
    }
    
    func testDelete() {
        theExpectation = expectationWithDescription("initialized")
        
        func myCallback(json: JSON?,data: NSData?, response: NSHTTPURLResponse?, error: NSError?) {
            theExpectation?.fulfill() // it will release our "timer"
            XCTAssertTrue(error == nil)
            XCTAssertTrue(response?.statusCode>199 && response?.statusCode<300)
        }
        
        let q = ["a":"z","b":"y"]
        Ricochet().delete(url, queryParms: q).request(myCallback)
        waitForExpectationsWithTimeout(20, handler: { error in XCTAssertNil(error, "Timeout on url \(self.url)")})
    }
    
    func testDeleteWithParams() {
        theExpectation = expectationWithDescription("initialized")
        
        func myCallback(json: JSON?,data: NSData?, response: NSHTTPURLResponse?, error: NSError?) {
            theExpectation?.fulfill() // it will release our "timer"
            XCTAssertTrue(error == nil)
            XCTAssertTrue(response?.statusCode>199 && response?.statusCode<300)
        }
        
        Ricochet().delete(url).request(myCallback)
        waitForExpectationsWithTimeout(20, handler: { error in XCTAssertNil(error, "Timeout on url \(self.url)")})
    }
}
