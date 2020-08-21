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
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: TimelineClient) {
        self.homeTimelineClient = client
    }
    //サーバーからタイムライン取得
    open func requestHomeTimeline() {
        
        disposeBag = DisposeBag()
        //API通信
        DispatchQueue.global(qos: .background).async {
            self.homeTimelineClient.getTimeline(with: OAuthClient())
                .subscribe(onSuccess: { [weak self] response in
                    self?.homeTimelineArrayEvent.onNext(response)
                    }, onError: { error in
                        print(error)
                })
                .disposed(by: self.disposeBag)
        }
    }
}
