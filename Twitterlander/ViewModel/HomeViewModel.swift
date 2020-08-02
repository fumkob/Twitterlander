//
//  HomeViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/13.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import RxSwift
import RxCocoa

open class HomeViewModel {
    private let homeTimelineClient: TimelineClient
    //APIデータ用
    private let homeTimelineArrayEvent = PublishSubject<[Timeline]>()
    open var homeTimelineArray: Driver<[Timeline]> {return homeTimelineArrayEvent.asDriver(onErrorDriveWith: .empty())}
    //詳細ツイート遷移データ用
    private let tweetDetailDataEvent = PublishSubject<TweetDetailData>()
    open var tweetDetailData: Driver<TweetDetailData> {return tweetDetailDataEvent.asDriver(onErrorDriveWith: .empty())}
    //プロフィール遷移データ用
    private let screenNameEvent = PublishSubject<String>()
    open var screenName: Driver<String> {return screenNameEvent.asDriver(onErrorDriveWith: .empty())}
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: TimelineClient) {
        self.homeTimelineClient = client
    }
    //サーバーからタイムライン取得
    open func requestHomeTimeline() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        guard let token = userDefaults.dictionary(forKey: "token") as? [String:String] else {
            fatalError("token is nil")
        }
        let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        disposeBag = DisposeBag()
        //API通信
        homeTimelineClient.getTimeline(url: url, token: token)
            .subscribeOn(backgroundScheduler)
            .subscribe(onSuccess: { [weak self] response in
                self?.homeTimelineArrayEvent.onNext(response)
                }, onError: { error in
                    print(error)
            })
            .disposed(by: disposeBag)
    }
    //詳細ツイート画面遷移
    open func transitionProcessToTweetDetail(homeTimeline: Timeline) {
        switch homeTimeline.retweetedStatus {
        case true:
            tweetDetailDataEvent.onNext(TweetDetailData(retweet: homeTimeline))
        case false:
            tweetDetailDataEvent.onNext(TweetDetailData(normalTweet: homeTimeline))
        }
    }
    //プロフィール画面遷移
    open func transitionProcessToProfile(homeTimeline: Timeline) {
        switch homeTimeline.retweetedStatus {
        case true:
            guard let retweetedScreenName = homeTimeline.retweetedScreenName else {
                fatalError("retweetedScreenName is nil")
            }
            ProfileViewInfo.shared.receiveScreenName.onNext(retweetedScreenName)
            screenNameEvent.onNext(retweetedScreenName)
        case false:
            ProfileViewInfo.shared.receiveScreenName.onNext(homeTimeline.screenName)
            screenNameEvent.onNext(homeTimeline.screenName)
        }
    }
}
