//
//  ProfileTweetViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/31.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import RxSwift
import RxCocoa

open class ProfileTweetViewModel {
    private let userTimelineClient: TimelineClient
    //APIデータ用
    private let userTimelineArrayEvent = PublishSubject<[Timeline]>()
    open var userTimelineArray: Driver<[Timeline]> {return userTimelineArrayEvent.asDriver(onErrorDriveWith: .empty())}
    //詳細ツイート遷移データ用
    private let tweetDetailDataEvent = PublishSubject<TweetDetailData>()
    open var tweetDetailData: Driver<TweetDetailData> {return tweetDetailDataEvent.asDriver(onErrorDriveWith: .empty())}
    //プロフィール遷移データ用
    private let screenNameEvent = PublishSubject<String>()
    open var screenName: Driver<String> {return screenNameEvent.asDriver(onErrorDriveWith: .empty())}
    //取得用スクリーン名
    private var givenScreenName: String = ""
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: TimelineClient) {
        self.userTimelineClient = client
    }
    //サーバーからタイムライン取得
    open func requestUserTimeline() {
        disposeBag = DisposeBag()
        
        ProfileViewInfo.shared.sendScreenName
            .subscribe(onNext: { name in
                self.givenScreenName = name
            })
            .disposed(by: disposeBag)
        
        let url = userTimelineUrlGenerator(screenName: givenScreenName)
        guard let token = userDefaults.dictionary(forKey: "token") as? [String:String] else {
            fatalError("token is nil")
        }
        //API通信
        DispatchQueue.global(qos: .background).async {
            self.userTimelineClient.getTimeline(url: url, token: token)
                .subscribe(onSuccess: { [weak self] response in
                    self?.userTimelineArrayEvent.onNext(response)
                    }, onError: { error in
                        print(error)
                })
                .disposed(by: self.disposeBag)
        }
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
    open func transitionProcessToProfile(userTimeline: Timeline) {
        switch userTimeline.retweetedStatus {
        case true:
            guard let retweetedScreenName = userTimeline.retweetedScreenName else {
                fatalError("retweetedScreenName is nil")
            }
            ProfileViewInfo.shared.receiveScreenName.onNext(retweetedScreenName)
            screenNameEvent.onNext(retweetedScreenName)
        case false:
            ProfileViewInfo.shared.receiveScreenName.onNext(userTimeline.screenName)
            screenNameEvent.onNext(userTimeline.screenName)
        }
    }
    open func userTimelineUrlGenerator(screenName: String) -> String {
        let baseUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let name = "screen_name=" + screenName
        let count = "count=20"
        let replies = "exclude_replies=true"
        let urlString = baseUrl + "?" + name + "&" + count + "&" + replies
        return urlString
    }
    //コンテンツ高さ送信
    open func postContentsHeight(height: CGFloat) {
//        print(height)
        ProfileViewInfo.shared.receiveTableHeight.onNext(height)
    }
}
