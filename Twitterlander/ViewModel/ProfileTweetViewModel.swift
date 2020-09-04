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
    private let screenName: String
    //APIデータ用
    private let userTimelineArrayEvent = PublishSubject<[Timeline]>()
    open var userTimelineArray: Driver<[Timeline]> {return userTimelineArrayEvent.asDriver(onErrorDriveWith: .empty())}
    //詳細ツイート遷移データ用
    private let tweetDetailDataEvent = PublishSubject<TweetDetailData>()
    open var tweetDetailData: Driver<TweetDetailData> {return tweetDetailDataEvent.asDriver(onErrorDriveWith: .empty())}
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: TimelineClient, screenName: String) {
        self.userTimelineClient = client
        self.screenName = screenName
    }
    //サーバーからタイムライン取得
    open func requestUserTimeline() {
        disposeBag = DisposeBag()
        
        let url = userTimelineUrlGenerator(screenName: screenName)
        
        //API通信
        DispatchQueue.global(qos: .background).async {
            self.userTimelineClient.getTimeline(with: OAuthClient(), url: url)
                .subscribe(onSuccess: { [weak self] response in
                    self?.userTimelineArrayEvent.onNext(response)
                    }, onError: { error in
                        print(error)
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    open func userTimelineUrlGenerator(screenName: String) -> URL {
        let baseUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let name = "screen_name=" + screenName
        let count = "count=20"
        let replies = "exclude_replies=true"
        let urlString = baseUrl + "?" + name + "&" + count + "&" + replies
        guard let url = URL(string: urlString) else {
            fatalError("Invalid url")
        }
        return url
    }
    //コンテンツ高さ送信
    open func postContentsHeight(height: CGFloat) {
//        print(height)
        ProfileViewInfo.shared.receiveTableHeight.onNext(height)
    }
}
