//
//  SearchClientTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/09/07.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
import SwiftyJSON
import Quick
import Nimble

@testable import Twitterlander

class SearchClientTests: QuickSpec {
    override func spec() {
        var searchClient: SearchClient!
        beforeEach {
            searchClient = SearchClient()
        }
        describe("Request URL") {
            it("changes correctly according to input screenName") {
                var screenName = "NissanJP"
                var generatedUrl = searchClient.searchUrlGenerator(screenName: screenName)
                expect(generatedUrl) == self.correctUrl(screenName: screenName)
                
                screenName = "Nissan"
                generatedUrl = searchClient.searchUrlGenerator(screenName: screenName)
                expect(generatedUrl) == self.correctUrl(screenName: screenName)
            }
        }
        describe("Search Client") {
            var exp: XCTestExpectation!
            beforeEach {
                exp = self.expectation(description: "Do not call")
                searchClient = SearchClient()
            }
            
            it("can fetch search result from API") {
                let oauthClientMock = OAuthClientMockFactory.dummyFileForSearchResultOAuthClient()
                searchClient.getSearchResult(with: oauthClientMock, screenName: "")
                    .subscribe(onSuccess: { response in
                        expect(response[0].screenName) == "k100339kenji"
                        exp.fulfill()
                    })
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("incompleted")
                }
            }
            
            it("throws decode error when server return unknown response") {
                let oauthClientMock = OAuthClientMockFactory.emptyOAuthClient()
                
                searchClient.getSearchResult(with: oauthClientMock, screenName: "")
                    .subscribe(onError: {error in
                        guard let error = error as? SearchClient.Error else {fail("unexepected error"); return}
                        switch error {
                        case .decodeError: break
                        default: fail("unexepected error")
                        }
                        exp.fulfill()
                    })
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
            
            it("throws wrongsetting error when url is not correct") {
                let oauthClientMock = OAuthClientMockFactory.wrongSettingErrorOAuthClient()
                searchClient.getSearchResult(with: oauthClientMock, screenName: "")
                    .subscribe(onError: {error in
                        guard let error = error as? SearchClient.Error else {
                            fail("unexepected error"); return
                        }
                        switch error {
                        case .oauthClientError(.wrongSetting): break
                        default: fail("unexepected error")
                        }
                        exp.fulfill()
                    })
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
            
            it("throws server error when the twitter server is down") {
                let oauthClientMock = OAuthClientMockFactory.serverErrorOAuthClient()
                
                searchClient.getSearchResult(with: oauthClientMock, screenName: "")
                    .subscribe(onError: {error in
                        guard let error = error as? SearchClient.Error else {fail("unexepected error"); return}
                        switch error {
                        case .oauthClientError(.serverError): break
                        default: fail("unexepected error")
                        }
                        exp.fulfill()
                    })
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
            
            it("throws unauthorized error when access denied or token expired") {
                let oauthClientMock = OAuthClientMockFactory.unauthorizedErrorOAuthClient()
                
                searchClient.getSearchResult(with: oauthClientMock, screenName: "")
                    .subscribe(onError: {error in
                        guard let error = error as? SearchClient.Error else {fail("unexepected error"); return}
                        switch error {
                        case .oauthClientError(.unauthorized): break
                        default: fail("unexepected error")
                        }
                        exp.fulfill()
                    })
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
        }
    }
    func correctUrl(screenName: String) -> String {
        return "https://api.twitter.com/1.1/search/tweets.json?q=to%3A" + screenName + "&count=100&result_type=recent"
    }
}

extension OAuthClientMockFactory {
    class OAuthClientSearchResultMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                let url = URL(fileURLWithPath: "searchResult.json", relativeTo: URL(fileURLWithPath: #file).deletingLastPathComponent())

                // swiftlint:disable force_try
                observer(.success(try! JSON.init(data: try! Data(contentsOf: url))))
                return Disposables.create()
            })
        }
    }
    
    static func dummyFileForSearchResultOAuthClient() -> OAuthClient {
        return OAuthClientSearchResultMock()
    }
}
