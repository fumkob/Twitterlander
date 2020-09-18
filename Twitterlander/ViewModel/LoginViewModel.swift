//
//  LoginViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/10.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class LoginViewModel {
    private var oauthClient: OAuthClient
    private var transitionToHomeEvent = BehaviorSubject<Bool>(value: false)
    public var transitionToHome: Driver<Bool> { return transitionToHomeEvent.asDriver(onErrorJustReturn: false)}
    
    private var disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    init(client: OAuthClient) {
        self.oauthClient = client
    }
    //OAuthTokenが保存されているか確認
    public func checkOAuthTokenExsits() {
        if let token = userDefaults.dictionary(forKey: "token") as? [String:String] {
            if !token.isEmpty {
                transitionToHomeEvent.onNext(true)
            }
        }
    }
    //OAuthTokenを取得
    public func loginProcessing() {
        oauthClient.getOAuthToken()
            .subscribe(onSuccess: { [weak self] token in
                self?.userDefaults.set(token, forKey: "token")
                self?.userDefaults.synchronize()
                self?.transitionToHomeEvent.onNext(true)
            }, onError: { error in
                print(error)
            })
        .disposed(by: disposeBag)
    }
    
    //Tokenを削除
    public func deleteToken() {
        userDefaults.removeObject(forKey: "token")
        transitionToHomeEvent.onNext(false)
    }
}
