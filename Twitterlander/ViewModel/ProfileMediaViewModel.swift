//
//  ProfileMediaViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/03.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import RxSwift
import RxCocoa

open class ProfileMediaViewModel {
    private let timelineClient: TimelineClient
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    //APIデータ用
    private let mediaUrlArrayEvent = PublishSubject<[URL?]>()
    open var mediaUrlArray: Driver<[URL?]> {return mediaUrlArrayEvent.asDriver(onErrorDriveWith: .empty())}
    private var mediaUrls: [URL?]!
    //遷移用
    private let mediaUrlTransitionEvent = PublishSubject<[URL?]>()
    open var mediaUrlTransition: Driver<[URL?]> {return mediaUrlTransitionEvent.asDriver(onErrorDriveWith: .empty())}
    //取得用スクリーン名
    private var givenScreenName: String = ""
    
    init(client: TimelineClient) {
        self.timelineClient = client
    }
    
    open func requestMediaInfo() {
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
            self.timelineClient.getTimeline(url: url, token: token)
                .subscribe(onSuccess: { [unowned self] response in
                    let urls = self.mediaUrlGenerator(response: response)
                    self.mediaUrlArrayEvent.onNext(urls)
                    self.mediaUrls = urls
                    }, onError: { error in
                        print(error)
                })
                .disposed(by: self.disposeBag)
        }
        
    }
    open func userTimelineUrlGenerator(screenName: String) -> String {
        let baseUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let name = "screen_name=" + screenName
        let count = "count=200"
        let replies = "exclude_replies=true"
        let urlString = baseUrl + "?" + name + "&" + count + "&" + replies
        return urlString
    }
    open func mediaUrlGenerator(response: [Timeline]) -> [URL?] {
        let filteredResponse = response.filter({!$0.isRetweeted})
        let urlString = filteredResponse.compactMap({$0.mediaUrl}).flatMap({$0})
        let urls = urlString.map({URL(string: $0)})
        return urls
    }
    //コンテンツ高さ送信
    open func postContentsHeight(height: CGFloat) {
//        print(height)
        ProfileViewInfo.shared.receiveCollectionHeight.onNext(height)
    }
    //Media Detail遷移処理
    open func transitionProcessToMediaDetail(row: Int) {
        ProfileViewInfo.shared.receiveRow.onNext(row)
        mediaUrlTransitionEvent.onNext(mediaUrls)
    }
}
