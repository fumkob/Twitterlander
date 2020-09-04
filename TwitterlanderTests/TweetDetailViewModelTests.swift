//
//  TweetDetailViewModelTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/07/27.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
@testable import Twitterlander

class TweetDetailViewModelTests: XCTestCase {
    let tweetDetailViewModel = TweetDetailViewModel(client: SearchClientMockFactory.SearchClientMock())
//    func testSearchUrlGenerator() {
//        let baseUrl = "https://api.twitter.com/1.1/search/tweets.json"
//        let screenName = "__APITest__"
//        let query = "q=to%3A" + screenName
//        let count = "count=100"
//        let resultType = "result_type=recent"
//        let expectedUrlString = baseUrl + "?" + query + "&" + count + "&" + resultType
//        let searchUrlGenerator = tweetDetailViewModel.searchUrlGenerator(screenName: screenName)
//        XCTAssertEqual(expectedUrlString, searchUrlGenerator)
//    }
    
    /*
    func testReplyExtractor() {
        let correctId = "12345"
        let wrongId = "22345"
        let searchResult = [
            SearchResult(forTest: ["screenName" : "A", "inReplyToStatusIdStr" : correctId]),
            SearchResult(forTest: ["screenName" : "B", "inReplyToStatusIdStr" : wrongId]),
            SearchResult(forTest: ["screenName" : "C", "inReplyToStatusIdStr" : correctId]),
            SearchResult(forTest: ["screenName" : "D", "inReplyToStatusIdStr" : correctId]),
            SearchResult(forTest: ["screenName" : "E", "inReplyToStatusIdStr" : wrongId]),
            SearchResult(forTest: ["screenName" : "F", "inReplyToStatusIdStr" : correctId])
        ]
        let correctArray = searchResult.filter {$0.inReplyToStatusIdStr == correctId}
        let tweetDetailData = TweetDetailData(forTest: ["screenName" : "X", "idStr" : correctId])
        let extractedReplies = tweetDetailViewModel.replyExtractor(response: searchResult, data: tweetDetailData)
        XCTAssertEqual(correctArray.map {$0.screenName}, extractedReplies.map {$0.screenName})
    }
 */
}

class SearchClientMockFactory {
    class SearchClientMock: SearchClient {
        override func getSearchResult(with client: OAuthClient, screenName: String) -> Single<[SearchResult]> {
            return .create(subscribe : {observer in
                observer(.success([]))
                return Disposables.create()
            })
        }
    }
    static func emptySearchClient() -> SearchClient {
        return SearchClientMock()
    }
}
