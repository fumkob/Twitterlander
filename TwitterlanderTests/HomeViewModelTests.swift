//
//  HomeViewModelTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/07/21.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Twitterlander

class HomeViewModelTests: XCTestCase {
    private var disposeBag = DisposeBag()
    /*
    func testRequestTimeline() {
        let scheduler = TestScheduler(initialClock: 0)
        let homeTimelineClient: HomeTimelineClient = HomeTimelineClientMockFactory.emptyHomeTimelineClient()
        let homeViewModel: HomeViewModel = HomeViewModel(client: homeTimelineClient)
        
        let xs = scheduler.createHotObservable([
            Recorded.next(100, TweetType.normal)
        ])
    }
*/
}

class HomeTimelineClientMockFactory {
    class HomeTimelineClientMock: HomeTimelineClient {
        override func getHomeTimeline(url: String, token: [String : String]) -> Single<[HomeTimeline]> {
            return .create(subscribe : {observer in
                observer(.success([]))
                return Disposables.create()
            })
        }
    }
    static func emptyHomeTimelineClient() -> HomeTimelineClient {
        return HomeTimelineClientMock()
    }
}
