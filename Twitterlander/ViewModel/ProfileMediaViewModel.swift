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
    private let screenName: String
    //APIデータ用
    private let mediaUrlArrayEvent = PublishSubject<[URL?]>()
    open var mediaUrlArray: Driver<[URL?]> {return mediaUrlArrayEvent.asDriver(onErrorDriveWith: .empty())}
    private var mediaUrls: [URL?]!
    //遷移用
    private let mediaUrlTransitionEvent = PublishSubject<[URL?]>()
    open var mediaUrlTransition: Driver<[URL?]> {return mediaUrlTransitionEvent.asDriver(onErrorDriveWith: .empty())}
    
    init(client: TimelineClient, screenName: String) {
        self.timelineClient = client
        self.screenName = screenName
    }
    
    open func requestMediaInfo() {
        
        let url = userTimelineUrlGenerator(screenName: screenName)
        
        //API通信
        DispatchQueue.global(qos: .background).async {
            self.timelineClient.getTimeline(with: OAuthClient(), url: url)
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
    open func userTimelineUrlGenerator(screenName: String) -> URL {
        let baseUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let name = "screen_name=" + screenName
        let count = "count=200"
        let replies = "exclude_replies=true"
        let urlString = baseUrl + "?" + name + "&" + count + "&" + replies
        guard let url = URL(string: urlString) else {
            fatalError("Invalid url")
        }
        return url
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
