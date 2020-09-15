//
//  CreateTweetViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/04.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateTweetViewController: UIViewController {

    @IBOutlet weak var tweetButton: CustomButton!
    @IBOutlet weak var tweetText: UITextField!
    
    private var createTweetViewModel: CreateTweetViewModel!
    private let disposeBag = DisposeBag()
    public weak var delegate: CreateTweetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTweetViewSetup()
        tweetButtonTapped()
        postCompleted()
    }
    private func createTweetViewSetup() {
        self.createTweetViewModel = CreateTweetViewModel(client: CreateTweetClient())
    }
    //ツイートボタンタップ
    private func tweetButtonTapped() {
        tweetButton.rx.tap
            .withLatestFrom(tweetText.rx.text.orEmpty)
            .subscribe(onNext: {[weak self] in
                if !$0.isEmpty {
                    self?.createTweetViewModel.requestCreatingTweet(tweet: $0)
                }
            })
        .disposed(by: disposeBag)
    }
    //ポスト完了処理
    private func postCompleted() {
        createTweetViewModel.createTweetStatus
            .drive(onNext: {[unowned self] status in
                switch status {
                case .success:
                    let alert = UIAlertController.okAlert(title: "Tweet完了", message: "Tweetを送信しました。", handler: {[unowned self] (_ : UIAlertAction) -> Void in
                        self.delegate?.dismissCreateView(self)
                    })
                    self.present(alert, animated: true, completion: nil)
                case .failure:
                let alert = UIAlertController.okAlert(title: "Tweet失敗", message: "Tweetが失敗しました。\n時間をおいて再度Tweetしてください。")
                self.present(alert, animated: true, completion: nil)
                case .onProgress:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}

protocol CreateTweetViewControllerDelegate: class {
    func dismissCreateView(_ viewController: CreateTweetViewController)
}
