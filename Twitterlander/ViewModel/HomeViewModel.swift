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
    private let homeTimelineClient: HomeTimelineClient
    //データ用
    private let homeTimelineArrayEvent = PublishSubject<[HomeTimeline]>()
    open var homeTimelineArray: Driver<[HomeTimeline]> {return homeTimelineArrayEvent.asDriver(onErrorJustReturn: [])}
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: HomeTimelineClient) {
        self.homeTimelineClient = client
    }
    //サーバーからタイムライン取得
    open func requestHomeTimeline() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        guard let token = userDefaults.dictionary(forKey: "token") as? [String:String] else {
            fatalError("token is nil")
        }
        
        disposeBag = DisposeBag()
        //API通信
        homeTimelineClient.getHomeTimeline(url: url, token: token)
            .subscribe(onSuccess: { [weak self] response in
                self?.homeTimelineArrayEvent.onNext(response)
                }, onError: { error in
                    print(error)
            })
            .disposed(by: disposeBag)
    }
    //プロフィール画面遷移
    open func profileImageToProfile() {
        
    }
}
