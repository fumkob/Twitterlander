//
//  ProfileViewModelTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/07/31.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
@testable import Twitterlander

class ProfileModelTests: XCTestCase {
    let profileViewModel = ProfileViewModel(client: ProfileClientMockFactory.emptyProfileClient(), screenName: "")
//    func testProfileUrlGenerator() {
//        let screenName = "test"
//        let baseUrl = "https://api.twitter.com/1.1/users/show.json"
//        let name = "screen_name=" + screenName
//        let urlString = baseUrl + "?" + name
//        let profileUrlGenerator = profileViewModel.profileUrlGenerator(screenName: screenName)
//        XCTAssertEqual(profileUrlGenerator, urlString)
//    }
    
    func testHeightLimit600() {
        let height:CGFloat = 599
        let limittedHeightResult = profileViewModel.heightLimit(height: height)
        XCTAssertEqual(600, limittedHeightResult)
    }
    func testHeightLimit100() {
        let height:CGFloat = 100
        let limittedHeightResult = profileViewModel.heightLimit(height: height)
        XCTAssertEqual(600, limittedHeightResult)
    }
    func testHeightLimit1000() {
        let height:CGFloat = 1000
        let limittedHeightResult = profileViewModel.heightLimit(height: height)
        XCTAssertEqual(height, limittedHeightResult)
    }
}

class ProfileClientMockFactory {
    class ProfileClientMock: ProfileClient {
        override func getProfile(with client: OAuthClient, screenName: String) -> Single<ProfileData> {
            return .create(subscribe : {observer in
                observer(.success(ProfileData(name: "",
                                              screenName: "",
                                              profileImageUrl: "",
                                              profileBannerUrl: nil,
                                              description: "",
                                              createdAt: Date(),
                                              location: "",
                                              link: nil,
                                              friendsCount: 0,
                                              followersCount: 0,
                                              following: false,
                                              verified: false)))
                return Disposables.create()
            })
        }
    }
    static func emptyProfileClient() -> ProfileClient {
        return ProfileClientMock()
    }
}
