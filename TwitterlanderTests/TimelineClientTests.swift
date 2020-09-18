//
//  TimelineClientTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/08/18.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
import SwiftyJSON
import Quick
import Nimble

@testable import Twitterlander

class TimelineClientTests: XCTestCase {
    
    func testExample() throws {
        let oauthClientMock = OAuthClientMockFactory.dummyFileOAuthClient()
        let timelineClient = TimelineClient()
        let url = URL(string: "http://")!
        
        let exp = self.expectation(description: "Do not call")
        
        timelineClient.getTimeline(with: oauthClientMock, url: url)
            .subscribe(onSuccess: { response in
                XCTAssertEqual(response[0].screenName, "NissanGlobal")
                exp.fulfill()
            })
        switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
        case .completed: break
        case .timedOut: XCTFail("timeout")
        default: XCTFail("uncompleted")
        }
    }
}

class TimelineClientTests2: QuickSpec {
    override func spec() {
        var timelineClient: TimelineClient!
        var url: URL!
        var exp: XCTestExpectation!
        beforeEach {
            timelineClient = TimelineClient()
            url = URL(string: "http://")!
            exp = self.expectation(description: "Do not call")
        }
        
        describe("Timeline client") {
            it("can fetch user_timeline from API") {
                let oauthClientMock = OAuthClientMockFactory.dummyFileOAuthClient()
                
                timelineClient.getTimeline(with: oauthClientMock, url: url)
                    .subscribe(onSuccess: {response in
                        expect(response[0].screenName) == "NissanGlobal"
                        exp.fulfill()
                    })
                switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
                case .completed: break
                case .timedOut: fail("timeout")
                default: fail("uncompleted")
                }
            }
            
            it("throws wrongsetting error when url is not correct") {
                let oauthClientMock = OAuthClientMockFactory.errorOAuthClient(type: .wrongSetting)
                timelineClient.getTimeline(with: oauthClientMock, url: url)
                    .subscribe(onError: {error in
                        switch self.errorConversion(error: error) {
                        case .wrongSetting: break
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
            
            it("throws decode error when server return unknown response") {
                let oauthClientMock = OAuthClientMockFactory.emptyOAuthClient()
                
                timelineClient.getTimeline(with: oauthClientMock, url: url)
                    .subscribe(onError: {error in
                        guard let error = error as? TimelineClient.Error else {fail("unexepected error"); return}
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
            
            it("throws server error when the twitter server is down") {
                let oauthClientMock = OAuthClientMockFactory.errorOAuthClient(type: .serverError)
                
                timelineClient.getTimeline(with: oauthClientMock, url: url)
                    .subscribe(onError: {error in
                        switch self.errorConversion(error: error) {
                        case .serverError: break
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
                let oauthClientMock = OAuthClientMockFactory.errorOAuthClient(type: .unauthorized)
                
                timelineClient.getTimeline(with: oauthClientMock, url: url)
                    .subscribe(onError: {error in
                        switch self.errorConversion(error: error) {
                        case .unauthorized: break
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
    
    func errorConversion(error: Error) -> APIError {
        guard let error = error as? TimelineClient.Error else {fail("unexepected error");return APIError.unknown}
        switch error {
        case .oauthClientError(.serverError): return APIError.serverError
        case .oauthClientError(.wrongSetting): return APIError.wrongSetting
        case .oauthClientError(.decodeError): return APIError.decodeError
        case .oauthClientError(.unauthorized): return APIError.unauthorized
        default : return APIError.unknown
        }
    }
}

class OAuthClientMockFactory {
    class OAuthClientMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                let url = URL(fileURLWithPath: "sample3.json", relativeTo: URL(fileURLWithPath: #file).deletingLastPathComponent())
                // swiftlint:disable force_try
                observer(.success(try! JSON.init(data: try! Data(contentsOf: url))))
                return Disposables.create()
            })
        }
        
    }
    
    class OAuthClientEmptyResponseMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                observer(.success(JSON(parseJSON: "{\"hoge\":1}")))
                return Disposables.create()
            })
        }
    }
    
    class OAuthClientErrorMock: OAuthClient {
        
        private let error: APIError
        
        init(error: APIError) {
            self.error = error
        }
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                observer(.error(self.error))
                return Disposables.create()
            })
        }
        override func postTweet(of url: URL) -> Single<JSON> {
            return .create(subscribe: {observer in
                observer(.error(self.error))
                return Disposables.create()
            })
        }
    }
    
    static func dummyFileOAuthClient() -> OAuthClient {
        return OAuthClientMock()
    }
    
    static func emptyOAuthClient() -> OAuthClient {
        return OAuthClientEmptyResponseMock()
    }
    
    static func errorOAuthClient(type error: APIError) -> OAuthClient {
        return OAuthClientErrorMock(error: error)
    }
}
