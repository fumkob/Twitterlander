//
//  MediaDetailViewModel.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/04.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import RxSwift
import RxCocoa

open class MediaDetailViewModel {
    //URL
    private let rowEvent = PublishSubject<Int>()
    open var row: Driver<Int> {return rowEvent.asDriver(onErrorDriveWith: .empty())}
    
    private var disposeBag = DisposeBag()
    
    //URL伝搬
    open func transferMediaUrl() {
        ProfileViewInfo.shared.sendRow
            .subscribe(onNext: { [weak self] row in
                self?.rowEvent.onNext(row)
            })
            .disposed(by: disposeBag)
    }
}
