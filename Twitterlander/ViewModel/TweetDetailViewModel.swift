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
        
        disposeBag = DisposeBag()
        //API通信
        DispatchQueue.global(qos: .background).async {
            self.searchClient.getSearchResult(with: OAuthClient(), screenName: data.screenName)
                .subscribe(onSuccess: { [weak self] response in
                    self?.searchResultEvent.onNext(response
                        .filter({$0.inReplyToStatusIdStr == data.idStr})
                    )
                    self?.activityIndicatorStatusEvent.onNext(false)
                    }, onError: { error in
                        print(error)
                })
                .disposed(by: self.disposeBag)
        }
    }
}
