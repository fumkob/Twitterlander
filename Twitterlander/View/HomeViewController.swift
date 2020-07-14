//
//  HomeViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/13.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    private var homeViewModel: HomeViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewSetup()
        tableSetup()
        navigationBarSetup()
        tableViewCellTapped()
    }
    private func homeViewSetup() {
        self.homeViewModel = HomeViewModel(client: HomeTimelineClient())
    }
    
    private func tableSetup() {
        tableView.register(UINib(nibName: "DefaultTweetCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
        //高さ調整
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        //セルにデータセット
        homeViewModel.requestHomeTimeline()
        let homeTimelineArray = self.homeViewModel.homeTimelineArray
        homeTimelineArray
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
                self?.profileImageTapped(cell: cell)
                return cell
        }
        .disposed(by: disposeBag)
    }
    //ナビゲーションバー設定
    private func navigationBarSetup() {
        self.navigationItem.title = "Home"
    }
    //セルタップ時処理
    private func tableViewCellTapped() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(HomeTimeline.self))
            .subscribe(onNext: { [weak self] indexPath, tweetData in
                self?.transitionToTweetDetail()
                //選択解除
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    //プロフィール画像タップ時処理
    private func profileImageTapped(cell: DefaultTweetCell) {
        let tapGesture = UITapGestureRecognizer()
        cell.profileImage.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: {[weak self] _ in
                self?.transitionToProfile()
            })
            .disposed(by: disposeBag)
    }
    //ツイート詳細遷移
    private func transitionToTweetDetail() {
        let tweetDetailStoryboard = UIStoryboard(name: "TweetDetail", bundle: nil)
        guard let tweetDetailViewController = tweetDetailStoryboard.instantiateViewController(withIdentifier: "tweetDetail") as? TweetDetailViewController else {
            fatalError("Storyboard named \"TweetDetail\" does NOT exists.")
        }
        navigationController?.pushViewController(tweetDetailViewController, animated: true)
    }
    //プロフィール画面遷移
    private func transitionToProfile() {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "profile") as? ProfileViewController else {
            fatalError("Storyboard named \"Profile\" does NOT exists.")
        }
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
