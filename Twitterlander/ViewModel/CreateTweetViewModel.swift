//
//  CreateTweetViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/04.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import RxSwift
import RxCocoa

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
    
    open func postTweet(tweet: String) {
        createTweetStatusEvent.onNext(.onProgress)
        let url = "https://api.twitter.com/1.1/statuses/update.json?status=" + tweet
        guard let urlEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            fatalError("Cannot Encode")
        }
        guard let token = userDefaults.dictionary(forKey: "token") as? [String:String] else {
            fatalError("token is nil")
        }
        let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        disposeBag = DisposeBag()
        //投稿
        createTweetClient.postTweet(url: urlEncoded, token: token)
            .subscribeOn(backgroundScheduler)
            .subscribe(onSuccess: { [unowned self] _ in
                    self.createTweetStatusEvent.onNext(.success)
                }, onError: { error in
                    print(error)
                    self.createTweetStatusEvent.onNext(.failure)
            })
            .disposed(by: disposeBag)
    }
}

public enum CreateTweetStatus {
    case success
    case failure
    case onProgress
}
