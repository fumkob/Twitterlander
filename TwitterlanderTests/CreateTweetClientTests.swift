//
//  CreateTweetClientTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/09/15.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
import SwiftyJSON
import Quick
import Nimble

@testable import Twitterlander

class CreateTweetClientTests: QuickSpec {
    override func spec() {
        var createTweetClient: CreateTweetClient!
        beforeEach {
            createTweetClient = CreateTweetClient()
        }
        describe("Request URL") {
            it("changes correctly according to input tweet") {
                let tweet = "This is a test.これはテスト。"
                let url = "https://api.twitter.com/1.1/statuses/update.json?status=" + tweet
                guard let correctUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    fatalError("Cannot Encode")
                }
                let generatedUrl = createTweetClient.createTweetUrlGenelator(tweet: tweet)
                expect(generatedUrl) == correctUrl
            }
        }
        describe("CreateTweet Client") {
            it("can fetch POST success result from API") {
                
            }
        }
    }
}
