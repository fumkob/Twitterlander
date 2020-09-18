//
//  ProfileMediaViewModelTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/08/03.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
@testable import Twitterlander

/*
class ProfileMediaModelTests: XCTestCase {
    let profileMediaViewModel = ProfileMediaViewModel(client: TimelineClientMockFactory.emptyTimelineClient())
    func testUserTimelineUrlGenerator() {
        let screenName = "test"
        let baseUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let name = "screen_name=" + screenName
        let count = "count=200"
        let replies = "exclude_replies=true"
        let urlString = baseUrl + "?" + name + "&" + count + "&" + replies
        let userTimelineUrl = profileMediaViewModel.userTimelineUrlGenerator(screenName: screenName)
        XCTAssertEqual(userTimelineUrl, urlString)
    }
    func testMediaUrlGenerator() {
        let emptyTimeline = Timeline(
            name: "",
            screenName: "",
            profileImageUrl: "",
            text: "",
            idStr: "",
            createdAt: Date(),
            retweetedStatus: false,
            retweetedIsReply: false,
            quotedStatus: false,
            retweetCount: 0,
            favoriteCount: 0,
            isRetweeted: false,
            isFavorited: false,
            verified: false,
            source: "",
            isReply: false
        )
        let timelineA = Timeline(
            name: "",
            screenName: "",
            profileImageUrl: "",
            text: "",
            idStr: "",
            createdAt: Date(),
            mediaUrl: ["a"],
            retweetedStatus: false,
            retweetedIsReply: false,
            quotedStatus: false,
            retweetCount: 0,
            favoriteCount: 0,
            isRetweeted: false,
            isFavorited: false,
            verified: false,
            source: "",
            isReply: false
        )
        let timelineBC = Timeline(
            name: "",
            screenName: "",
            profileImageUrl: "",
            text: "",
            idStr: "",
            createdAt: Date(),
            mediaUrl: ["b", "c"],
            retweetedStatus: false,
            retweetedIsReply: false,
            quotedStatus: false,
            retweetCount: 0,
            favoriteCount: 0,
            isRetweeted: false,
            isFavorited: false,
            verified: false,
            source: "",
            isReply: false
        )
        let timelineD = Timeline(
            name: "",
            screenName: "",
            profileImageUrl: "",
            text: "",
            idStr: "",
            createdAt: Date(),
            mediaUrl: ["d"],
            retweetedStatus: false,
            retweetedIsReply: false,
            quotedStatus: false,
            retweetCount: 0,
            favoriteCount: 0,
            isRetweeted: true,
            isFavorited: false,
            verified: false,
            source: "",
            isReply: false
        )
        let timelineArray = [emptyTimeline,timelineA,emptyTimeline,emptyTimeline,timelineBC,emptyTimeline,timelineD,emptyTimeline]
        let expectedUrls: [URL?] = [URL(string: "a"), URL(string: "b"), URL(string: "c")]
        let mediaUrls = profileMediaViewModel.mediaUrlGenerator(response: timelineArray)
        XCTAssertEqual(mediaUrls, expectedUrls)
    }
}
*/
