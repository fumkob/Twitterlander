//
//  CreateTweetViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/04.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import RxSwift
import RxCocoa

public enum CreateTweetStatus {
    case success
    case failure
    case onProgress
}

open class CreateTweetViewModel {
    private let createTweetClient: CreateTweetClient
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    //ツイート完了通知
    private let createTweetStatusEvent = PublishSubject<CreateTweetStatus>()
    open var createTweetStatus: Driver<CreateTweetStatus> {return createTweetStatusEvent.asDriver(onErrorDriveWith: .empty())}
    
    init(client: CreateTweetClient) {
        self.createTweetClient = client
    }
    
    open func requestCreatingTweet(tweet: String) {
        createTweetStatusEvent.onNext(.onProgress)
//        let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        disposeBag = DisposeBag()
        //投稿
        createTweetClient.createTweet(with: OAuthClient(), tweet: tweet)
            .subscribe(onSuccess: { [unowned self] _ in
                self.createTweetStatusEvent.onNext(.success)
                }, onError: { error in
                    print(error)
                    self.createTweetStatusEvent.onNext(.failure)
            })
            .disposed(by: disposeBag)
        
    }
}
