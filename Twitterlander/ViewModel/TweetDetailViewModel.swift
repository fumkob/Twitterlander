//
//  TweetDetailViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/27.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

open class TweetDetailViewModel {
    private let searchClient: SearchClient
    
    //詳細ツイート遷移データ用
    private let searchResultEvent = PublishSubject<[SearchResult]>()
    open var searchResult: Driver<[SearchResult]> {return searchResultEvent.asDriver(onErrorDriveWith: .empty())}
    //プロフィール遷移データ用
    private let screenNameEvent = PublishSubject<String>()
    open var screenName: Driver<String> {return screenNameEvent.asDriver(onErrorDriveWith: .empty())}
    //Indicator用
    private let activityIndicatorStatusEvent = PublishSubject<Bool>()
    open var activityindicatorStatus: Driver<Bool> {return activityIndicatorStatusEvent.asDriver(onErrorDriveWith: .empty())}
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: SearchClient) {
        self.searchClient = client
    }
    //サーバーから検索結果取得
    open func getReplies(tweetDetailData data: TweetDetailData) {
        activityIndicatorStatusEvent.onNext(true)
        
        let url = searchUrlGenerator(screenName: data.screenName)
        guard let token = userDefaults.dictionary(forKey: "token") as? [String:String] else {
            fatalError("token is nil")
        }
        let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        disposeBag = DisposeBag()
        //API通信
        searchClient.getSearchResult(url: url, token: token)
            .subscribeOn(backgroundScheduler)
            .subscribe(onSuccess: { [weak self] response in
                self?.searchResultEvent.onNext(response
                    .filter({$0.inReplyToStatusIdStr == data.idStr})
                )
                self?.activityIndicatorStatusEvent.onNext(false)
                }, onError: { error in
                    print(error)
            })
            .disposed(by: disposeBag)
    }
    
    //プロフィール画面遷移
    open func transitionProcessToProfile(name: String) {
        ProfileViewInfo.shared.receiveScreenName.onNext(name)
        screenNameEvent.onNext(name)
    }
    
    open func searchUrlGenerator(screenName: String) -> String {
        let baseUrl = "https://api.twitter.com/1.1/search/tweets.json"
        let query = "q=to%3A" + screenName
        let count = "count=100"
        let resultType = "result_type=recent"
        let urlString = baseUrl + "?" + query + "&" + count + "&" + resultType
        return urlString
    }
}
