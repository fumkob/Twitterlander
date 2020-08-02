//
//  ProfileViewInformation.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/02.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import RxSwift
import RxCocoa

class ProfileViewInfo {
    static let shared = ProfileViewInfo()
    private let disposeBag = DisposeBag()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    
    private let receiveHeightStream = PublishSubject<CGFloat>()
    public var receiveHeight: AnyObserver<CGFloat> { return receiveHeightStream.asObserver()}
    
    private let sendHeightStream = PublishSubject<CGFloat>()
    public var sendHeight: Observable<CGFloat> {return sendHeightStream.asObservable()}
    
    private let receiveScreenNameStream = PublishSubject<String>()
    public var receiveScreenName: AnyObserver<String> { return receiveScreenNameStream.asObserver()}
    
    private let sendScreenNameStream = BehaviorSubject<String>(value: "")
    public var sendScreenName: Observable<String> {return sendScreenNameStream.asObservable()}
    
    private let receiveRowStream = PublishSubject<Int>()
    public var receiveRow: AnyObserver<Int> { return receiveRowStream.asObserver()}
    
    private let sendRowStream = BehaviorSubject<Int>(value: 0)
    public var sendRow: Observable<Int> {return sendRowStream.asObservable()}
    
    private init() {
        receiveHeightStream
        .observeOn(backgroundScheduler)
            .subscribe(onNext: {[weak self] in
            self?.sendHeightStream.onNext($0)
        })
            .disposed(by: disposeBag)
        
        receiveScreenNameStream.subscribe(onNext: {[weak self] in
            self?.sendScreenNameStream.onNext($0)
        })
            .disposed(by: disposeBag)
        
        receiveRowStream.subscribe(onNext: {[weak self] in
            self?.sendRowStream.onNext($0)
        })
            .disposed(by: disposeBag)
    }
}
