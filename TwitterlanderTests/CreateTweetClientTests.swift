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
        var disposeBag: DisposeBag!
        beforeEach {
            createTweetClient = CreateTweetClient()
            disposeBag = DisposeBag()
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
            var exp: XCTestExpectation!
            beforeEach {
                exp = self.expectation(description: "Do Not Call.")
            }
            it("can fetch POST success result from API") {
                let tweet = "Tweet Test."
                createTweetClient.createTweet(with: OAuthClientMockFactory.dummyFileForCreateTweetOAuthClient(), tweet: tweet)
                    .subscribe(onSuccess: {response in
                        expect(response["text"].string) == tweet
                        exp.fulfill()
                    })
                    .disposed(by: disposeBag)
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
            
            it("throws wrongsetting error when url is not correct") {
                let oauthClientMock = OAuthClientMockFactory.errorOAuthClient(type: .wrongSetting)
                createTweetClient.createTweet(with: oauthClientMock, tweet: "test")
                    .subscribe(onError: {error in
                        switch self.errorConversion(error: error) {
                        case .wrongSetting: break
                        default: fail("unexepected error")
                        }
                        exp.fulfill()
                    })
                    .disposed(by: disposeBag)
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
            
            it("throws server error when the twitter server is down") {
                let oauthClientMock = OAuthClientMockFactory.errorOAuthClient(type: .serverError)
                
                createTweetClient.createTweet(with: oauthClientMock, tweet: "")
                    .subscribe(onError: {error in
                        switch self.errorConversion(error: error) {
                        case .serverError: break
                        default: fail("unexepected error")
                        }
                        exp.fulfill()
                    })
                    .disposed(by: disposeBag)
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
            
            it("throws unauthorized error when access denied or token expired") {
                let oauthClientMock = OAuthClientMockFactory.errorOAuthClient(type: .unauthorized)
                
                createTweetClient.createTweet(with: oauthClientMock, tweet: "")
                    .subscribe(onError: {error in
                        switch self.errorConversion(error: error) {
                        case .unauthorized: break
                        default: fail("unexepected error")
                        }
                        exp.fulfill()
                    })
                    .disposed(by: disposeBag)
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
        }
    }
    
    func errorConversion(error: Error) -> APIError {
        guard let error = error as? CreateTweetClient.Error else {fail("unexepected error");return APIError.unknown}
        switch error {
        case .oauthClientError(.serverError): return APIError.serverError
        case .oauthClientError(.wrongSetting): return APIError.wrongSetting
        case .oauthClientError(.decodeError): return APIError.decodeError
        case .oauthClientError(.unauthorized): return APIError.unauthorized
        default : return APIError.unknown
        }
    }
}

extension OAuthClientMockFactory {
    class OAuthClientCreateTweetMock: OAuthClient {
        override func postTweet(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                let url = URL(fileURLWithPath: "PostResponse.json", relativeTo: URL(fileURLWithPath: #file).deletingLastPathComponent())

                // swiftlint:disable force_try
                observer(.success(try! JSON.init(data: try! Data(contentsOf: url))))
                return Disposables.create()
            })
        }
    }
    
    static func dummyFileForCreateTweetOAuthClient() -> OAuthClient {
        return OAuthClientCreateTweetMock()
    }
}
