//
//  ProfileTweetViewModelTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/08/03.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
@testable import Twitterlander

//class ProfileTweetModelTests: XCTestCase {
//    let profileTweetViewModel = ProfileTweetViewModel(client: TimelineClientMockFactory.emptyTimelineClient())
//    func testUserTimelineUrlGenerator() {
//        let screenName = "test"
//        let baseUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
//        let name = "screen_name=" + screenName
//        let count = "count=20"
//        let replies = "exclude_replies=true"
//        let urlString = baseUrl + "?" + name + "&" + count + "&" + replies
//        let userTimelineUrl = profileTweetViewModel.userTimelineUrlGenerator(screenName: screenName)
//        XCTAssertEqual(userTimelineUrl, urlString)
//    }
//}
