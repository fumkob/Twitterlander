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
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
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
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
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
        }
        
        describe("Timeline client") {
            it("throws wrongsetting error when url is not correct") {
                let oauthClientMock = OAuthClientMockFactory.wrongSettingErrorOAuthClient()
                timelineClient.getTimeline(with: oauthClientMock, url: url)
                    .subscribe(onError: {error in
                        guard let error = error as? TimelineClient.Error else {
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
                let oauthClientMock = OAuthClientMockFactory.serverErrorOAuthClient()
                
                timelineClient.getTimeline(with: oauthClientMock, url: url)
                    .subscribe(onError: {error in
                        guard let error = error as? TimelineClient.Error else {fail("unexepected error"); return}
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
                
                timelineClient.getTimeline(with: oauthClientMock, url: url)
                    .subscribe(onError: {error in
                        guard let error = error as? TimelineClient.Error else {fail("unexepected error"); return}
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
}

class OAuthClientMockFactory {
    class OAuthClientMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                let url = URL(fileURLWithPath: "/Users/fumiaki/Documents/Training/Twitterlander/Twitterlander/Twitterlander/TestGround/JsonTest.playground/Resources/sample3.json")
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
    
    class OAuthClientWrongSettingErrorMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                observer(.error(APIError.wrongSetting))
                return Disposables.create()
            })
        }
    }
    
    class OAuthClientServerErrorMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                observer(.error(APIError.serverError))
                return Disposables.create()
            })
        }
    }
    
    class OAuthClientUnauthorizedErrorMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                observer(.error(APIError.unauthorized))
                return Disposables.create()
            })
        }
    }
    
    class OAuthClientUrlRequestErrorMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                
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
    
    static func wrongSettingErrorOAuthClient() -> OAuthClient {
        return OAuthClientWrongSettingErrorMock()
    }
    
    static func serverErrorOAuthClient() -> OAuthClient {
        return OAuthClientServerErrorMock()
    }
    
    static func unauthorizedErrorOAuthClient() -> OAuthClient {
        return OAuthClientUnauthorizedErrorMock()
    }
}
