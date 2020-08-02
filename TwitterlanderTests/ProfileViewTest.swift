//
//  ProfileViewTest.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/07/31.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
@testable import Twitterlander

class ProfileViewControllerTests: XCTestCase {
    let profileViewController = ProfileViewController()
    
    func testCalculateAlpha() {
        let yLocation1: CGFloat = -100
        let expectedAlpha1 = profileViewController.calculateAlpha(yLocatioin: yLocation1)
        XCTAssertEqual(0, expectedAlpha1)
        let yLocation2: CGFloat = 0
        let expectedAlpha2 = profileViewController.calculateAlpha(yLocatioin: yLocation2)
        XCTAssertEqual(1, expectedAlpha2)
        let yLocation3: CGFloat = 1000
        let expectedAlpha3 = profileViewController.calculateAlpha(yLocatioin: yLocation3)
        XCTAssertEqual(1, expectedAlpha3)
        let yLocation4: CGFloat = -40
        let expectedAlpha4 = profileViewController.calculateAlpha(yLocatioin: yLocation4)
        XCTAssertEqual(1 - (yLocation4 / -64), expectedAlpha4)
    }
}
