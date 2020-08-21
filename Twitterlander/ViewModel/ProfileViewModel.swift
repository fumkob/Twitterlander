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
    private let screenName: String
    
    //プロフィールデータ
    private let profileDataEvent = PublishSubject<ProfileData>()
    open var profileData: Driver<ProfileData> {return profileDataEvent.asDriver(onErrorDriveWith: .empty())}
    
    private let viewHeightEvent = PublishSubject<CGFloat>()
    open var viewHeight: Driver<CGFloat> {return viewHeightEvent.asDriver(onErrorDriveWith: .empty())}
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: ProfileClient, screenName: String) {
        self.profileClient = client
        self.screenName = screenName
    }
    //サーバーから検索結果取得
    open func getProfile(screenName name: String) {
        
        disposeBag = DisposeBag()
        
        let scheduler = SerialDispatchQueueScheduler(qos: .background)
        
        //API通信
        //        DispatchQueue.global(qos: .background).async {
        self.profileClient.getProfile(with: OAuthClient(), screenName: screenName)
            .observeOn(scheduler)
            .subscribe(onSuccess: { [weak self] response in
                self?.profileDataEvent.onNext(response)
                }, onError: { error in
                    print(error)
            })
            .disposed(by: self.disposeBag)
        //        }
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
