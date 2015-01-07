//
//  RingTests.swift
//  sensors
//
//  Created by Maurizio Tidei on 23/12/14.
//  Copyright (c) 2014 contexagon. All rights reserved.
//

import UIKit
import XCTest

class RingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAverage() {
        
        var ring = NumericRing<Double>(capacity:4)
        
        ring.add(1.0)
        ring.add(2.0)
        ring.add(3.0)
        ring.add(4.0)
        
        XCTAssertEqual(2.5, ring.average(), "Should get the average of all added values")
    }
    
    func testNthToLast() {
        
        var ring = NumericRing<Double>(capacity:4)
        
        ring.add(1.0)
        ring.add(2.0)
        ring.add(3.0)
        ring.add(4.0)
        
        XCTAssertEqual(3.0, ring.getNToLast(2), "Should get the 2nd to last entry")
    }
    
    func testNthToLastOverCapacity() {
        
        var ring = NumericRing<Double>(capacity:4)
        
        ring.add(1.0)
        ring.add(2.0)
        ring.add(3.0)
        ring.add(4.0)
        ring.add(5.0)
        ring.add(6.0)
        
        XCTAssertEqual(5.0, ring.getNToLast(2), "Should get the 2nd to last entry")
    }
}