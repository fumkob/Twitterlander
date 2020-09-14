//
//  ProfileClientTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/09/14.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
import SwiftyJSON
import Quick
import Nimble

@testable import Twitterlander

class ProfileClientTests: QuickSpec {
    override func spec() {
        var profileClient: ProfileClient!
        beforeEach {
            profileClient = ProfileClient()
        }
        describe("Request URL") {
            it("changes correctly according to input screenName") {
                var screenName = "NissanJP"
                var generatedUrl = profileClient.profileUrlGenerator(screenName: screenName)
                expect(generatedUrl) == self.correctUrl(screenName: screenName)
                
                screenName = "Nissan"
                generatedUrl = profileClient.profileUrlGenerator(screenName: screenName)
                expect(generatedUrl) == self.correctUrl(screenName: screenName)
            }
        }
        
        describe("Profile Client") {
            var exp: XCTestExpectation!
            beforeEach {
                exp = self.expectation(description: "Do not call")
                profileClient = ProfileClient()
            }
            
            it("can fetch search result from API") {
                let oauthClientMock = OAuthClientMockFactory.dummyFileForProfileDataOAuthClient()
                profileClient.getProfile(with: oauthClientMock, screenName: "")
                    .subscribe(onSuccess: { response in
                        expect(response.name) == "日産自動車株式会社"
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
                
                profileClient.getProfile(with: oauthClientMock, screenName: "")
                    .subscribe(onError: {error in
                        guard let error = error as? ProfileClient.Error else {fail("unexepected error"); return}
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
                profileClient.getProfile(with: oauthClientMock, screenName: "")
                    .subscribe(onError: {error in
                        guard let error = error as? ProfileClient.Error else {
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
                
                profileClient.getProfile(with: oauthClientMock, screenName: "")
                    .subscribe(onError: {error in
                        guard let error = error as? ProfileClient.Error else {fail("unexepected error"); return}
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
                
                profileClient.getProfile(with: oauthClientMock, screenName: "")
                    .subscribe(onError: {error in
                        guard let error = error as? ProfileClient.Error else {fail("unexepected error"); return}
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
        return "https://api.twitter.com/1.1/users/show.json?screen_name=" + screenName
    }
}

extension OAuthClientMockFactory {
    class OAuthClientProfileDataMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
                let url = URL(fileURLWithPath: "ProfileData.json", relativeTo: URL(fileURLWithPath: #file).deletingLastPathComponent())

                // swiftlint:disable force_try
                observer(.success(try! JSON.init(data: try! Data(contentsOf: url))))
                return Disposables.create()
            })
        }
    }
    
    static func dummyFileForProfileDataOAuthClient() -> OAuthClient {
        return OAuthClientProfileDataMock()
    }
}
