//
//  ProfileTweetViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/30.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileTweetViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var profileTweetViewModel: ProfileTweetViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileTweet ViewDidLoad")

        tableSetup()
        tableViewCellTapped()
        heightSetup()
    }
    
    private func profileTweetViewSetup(screenName: String) {
        self.profileTweetViewModel = ProfileTweetViewModel(client: TimelineClient(), screenName: screenName)
    }
    
    private func tableSetup() {
        tableView.register(UINib(nibName: "DefaultTweetCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
        //セルにデータセット
        profileTweetViewModel.requestUserTimeline()
        profileTweetViewModel.userTimelineArray
            .drive(tableView.rx.items) {[weak self] tableView, _, data in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as? DefaultTweetCell else {
                    fatalError("cell is nil")
                }
                switch data.retweetedStatus {
                case true:
                    cell.retweetSetup(data: data)
                case false:
                    cell.defaultTweetSetup(data: data)
                }
                //プロフィール画像タップ時処理
                self?.profileImageTapped(cell: cell, data: data)
                return cell
        }
        .disposed(by: disposeBag)
    }
    
    //セルタップ時処理
    private func tableViewCellTapped() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Timeline.self))
            .subscribe(onNext: { [weak self] indexPath, data in
                self?.transitionToTweetDetail(data: data)
                //選択解除
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    //プロフィール画像タップ時処理
    private func profileImageTapped(cell: DefaultTweetCell, data: Timeline) {
        let tapGesture = UITapGestureRecognizer()
        cell.profileImage.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: {[weak self] _ in
                self?.transitionToProfile(data: data)
            })
            .disposed(by: disposeBag)
    }
    
    private func heightSetup() {
        //テーブル高さ設定
        tableView.rx.observe(CGSize.self, "contentSize")
            .subscribe(onNext: { [weak self] size in
                if let size = size {
                    self?.profileTweetViewModel.postContentsHeight(height: size.height)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //ツイート詳細遷移
    private func transitionToTweetDetail(data: Timeline) {
        var tweetDetailData: TweetDetailData!
        switch data.retweetedStatus {
        case true:
            tweetDetailData = TweetDetailData(retweet: data)
        case false:
            tweetDetailData = TweetDetailData(normalTweet: data)
        }
        let tweetDetailStoryboard = UIStoryboard(name: "TweetDetail", bundle: nil)
        guard let tweetDetailViewController = tweetDetailStoryboard.instantiateViewController(withIdentifier: "tweetDetail") as? TweetDetailViewController else {
            fatalError("Storyboard named \"TweetDetail\" does NOT exists.")
        }
        tweetDetailViewController.tweetDetailData = tweetDetailData
        navigationController?.pushViewController(tweetDetailViewController, animated: true)
    }
    //プロフィール画面遷移
    private func transitionToProfile(data: Timeline) {
        var screenName: String = ""
        switch data.retweetedStatus {
        case true:
            guard let retweetedScreenName = data.retweetedScreenName else {
                fatalError("retweetedScreenName is nil")
            }
            screenName = retweetedScreenName
        case false:
            screenName = data.screenName
        }
        let profileViewController = ProfileViewController.makeInstance(screenName: screenName)
        navigationController?.pushViewController(profileViewController, animated: true)
        
    }
}

extension ProfileTweetViewController {
    static func makeInstance(screenName: String) -> ProfileTweetViewController {
        guard let controller = UIStoryboard(name: "ProfileTweet", bundle: nil).instantiateViewController(withIdentifier: "profileTweet") as? ProfileTweetViewController else {fatalError("invalid controller")}
        controller.profileTweetViewSetup(screenName: screenName)
        return controller
    }
}
