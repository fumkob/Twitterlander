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
    public var screenName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileTweet ViewDidLoad")

        profileTweetViewSetup()
        tableSetup()
        tableViewCellTapped()
        transitionToTweetDetail()
        transitionToProfile()
        heightSetup()
    }
    
    private func profileTweetViewSetup() {
        self.profileTweetViewModel = ProfileTweetViewModel(client: TimelineClient())
        tableView.register(UINib(nibName: "DefaultTweetCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
    }
    
    private func tableSetup() {
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
                self?.profileTweetViewModel.transitionProcessToTweetDetail(homeTimeline: data)
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
                self?.profileTweetViewModel.transitionProcessToProfile(userTimeline: data)
            })
            .disposed(by: disposeBag)
    }
    //ツイート詳細遷移
    private func transitionToTweetDetail() {
        profileTweetViewModel.tweetDetailData
            .drive(onNext: {[weak self] tweetDetailData in
                let tweetDetailStoryboard = UIStoryboard(name: "TweetDetail", bundle: nil)
                guard let tweetDetailViewController = tweetDetailStoryboard.instantiateViewController(withIdentifier: "tweetDetail") as? TweetDetailViewController else {
                    fatalError("Storyboard named \"TweetDetail\" does NOT exists.")
                }
                tweetDetailViewController.tweetDetailData = tweetDetailData
                self?.navigationController?.pushViewController(tweetDetailViewController, animated: true)

            })
            .disposed(by: disposeBag)
    }
    //プロフィール画面遷移
    private func transitionToProfile() {
        profileTweetViewModel.screenName
            .drive(onNext: {[weak self] screenName in
                let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                guard let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "profile") as? ProfileViewController else {
                    fatalError("Storyboard named \"Profile\" does NOT exists.")
                }
                profileViewController.screenName = screenName
                self?.navigationController?.pushViewController(profileViewController, animated: true)
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
}
