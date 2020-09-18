//
//  TimeCalculationTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/07/17.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
@testable import Twitterlander

class TimeCalculationTests: XCTestCase {
    let timeCalculation = TimeCalculation()
    
    func testCalculationWithin60sec() {
        let createdAt = Date()
        let delayTime:Double = -27.4
        let delayedCreatedAt = createdAt.addingTimeInterval(delayTime)
        let result = timeCalculation.dateToString(createdAt: delayedCreatedAt)
        let expectedResult = "・\(Int(-delayTime))秒"
        XCTAssertEqual(result, expectedResult, "Calculation within 60sec is incorrect")
    }
    
    func testCalculationWithin60min() {
        let createdAt = Date()
        let delayTime:Double = -535
        let delayedCreatedAt = createdAt.addingTimeInterval(delayTime)
        let result = timeCalculation.dateToString(createdAt: delayedCreatedAt)
        let expectedResult = "・\(Int(-delayTime/60))分"
        XCTAssertEqual(result, expectedResult, "Calculation within 60sec is incorrect")
    }
    
    func testCalculationWithin1day() {
        let createdAt = Date()
        let delayTime:Double = -7823
        let delayedCreatedAt = createdAt.addingTimeInterval(delayTime)
        let result = timeCalculation.dateToString(createdAt: delayedCreatedAt)
        let expectedResult = "・\(Int(-delayTime/60/60))時間"
        XCTAssertEqual(result, expectedResult, "Calculation within 60sec is incorrect")
    }
    
    func testCalculationWithin1week() {
        let createdAt = Date()
        let delayTime:Double = -345612
        let delayedCreatedAt = createdAt.addingTimeInterval(delayTime)
        let result = timeCalculation.dateToString(createdAt: delayedCreatedAt)
        let expectedResult = "・\(Int(-delayTime/60/60/24))日"
        XCTAssertEqual(result, expectedResult, "Calculation within 60sec is incorrect")
    }
    
    func testCalculationOver1week() {
        let createdAt = Date()
        let delayTime:Double = -13456120
        let delayedCreatedAt = createdAt.addingTimeInterval(delayTime)
        let result = timeCalculation.dateToString(createdAt: delayedCreatedAt)
        let expectedResult = "・" + delayedCreatedAt.twitterDateStyle()
        XCTAssertEqual(result, expectedResult, "Calculation within 60sec is incorrect")
    }
}
