//
//  redditTests.swift
//  redditTests
//
//  Created by Anthony Gallo on 3/17/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import XCTest
@testable import reddit

class redditTests: XCTestCase {
    
    var cachingService: CachingService<NSString, NSString>!
    override func setUp() {
        super.setUp()
        cachingService = CachingService<NSString, NSString>(cacheLimit: 2)
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testCacheLimit() {
        let key1 = "testKey1" as NSString
        let key2 = "testKey2" as NSString
        let key3 = "testKey3" as NSString
        
        let value1 = "testValue1" as NSString
        let value2 = "testValue2" as NSString
        let value3 = "testValue3" as NSString
        
        cachingService.setObject(value1, forKey: key1)
        cachingService.setObject(value2, forKey: key2)
        cachingService.setObject(value3, forKey: key3)
        
        XCTAssertEqual(cachingService.getObject(forKey: key2), value2)
        XCTAssertEqual(cachingService.getObject(forKey: key3), value3)
        XCTAssertNil(cachingService.getObject(forKey: key1))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
