//
//  ProfileViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/31.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

open class ProfileViewModel {
    private let profileClient: ProfileClient
    
    //プロフィールデータ
    private let profileDataEvent = PublishSubject<ProfileData>()
    open var profileData: Driver<ProfileData> {return profileDataEvent.asDriver(onErrorDriveWith: .empty())}
    
    private let viewHeightEvent = PublishSubject<CGFloat>()
    open var viewHeight: Driver<CGFloat> {return viewHeightEvent.asDriver(onErrorDriveWith: .empty())}
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: ProfileClient) {
        self.profileClient = client
    }
    //サーバーから検索結果取得
    open func getProfile(screenName name: String) {
        
        let url = profileUrlGenerator(screenName: name)
        guard let token = userDefaults.dictionary(forKey: "token") as? [String:String] else {
            fatalError("token is nil")
        }
        let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        disposeBag = DisposeBag()
        //API通信
        profileClient.getProfile(url: url, token: token)
            .subscribeOn(backgroundScheduler)
            .subscribe(onSuccess: { [weak self] response in
                self?.profileDataEvent.onNext(response)
                }, onError: { error in
                    print(error)
            })
            .disposed(by: disposeBag)
    }
    
    open func profileUrlGenerator(screenName: String) -> String {
        let baseUrl = "https://api.twitter.com/1.1/users/show.json"
        let name = "screen_name=" + screenName
        let urlString = baseUrl + "?" + name
        return urlString
    }
    
    //Table高さ伝搬
    open func transferViewHeight() {
        ProfileViewInfo.shared.sendHeight
            .subscribe(onNext: { [unowned self] height in
                let newHeight = self.heightLimit(height: height)
                self.viewHeightEvent.onNext(newHeight)
            })
            .disposed(by: disposeBag)
    }
    //height Limit
    open func heightLimit(height: CGFloat) -> CGFloat {
        if height < 600 {
            return 600
        } else {
            return height
        }
    }
}
