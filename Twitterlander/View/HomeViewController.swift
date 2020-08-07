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
    @IBOutlet weak var plusButtonImage: UIImageView!
    private var reloadButton: UIBarButtonItem!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewSetup()
        tableSetup()
        navigationBarSetup()
        tableViewCellTapped()
        transitionToTweetDetail()
        transitionToProfile()
        plusButtonImageTapped()
    }
    
    private func homeViewSetup() {
        self.homeViewModel = HomeViewModel(client: TimelineClient())
    }
    
    private func tableSetup() {
        tableView.register(UINib(nibName: "DefaultTweetCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
        
        //セルにデータセット
        homeViewModel.requestHomeTimeline()
        homeViewModel.homeTimelineArray
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
    //ナビゲーションバー設定
    private func navigationBarSetup() {
        self.navigationItem.title = "Home"
        self.navigationController!.navigationBar.tintColor = .black
        reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        self.navigationItem.rightBarButtonItems = [reloadButton]
        
        reloadButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.homeViewModel.requestHomeTimeline()
            })
            .disposed(by: disposeBag)
    }
    //セルタップ時処理
    private func tableViewCellTapped() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Timeline.self))
            .subscribe(onNext: { [weak self] indexPath, data in
                self?.homeViewModel.transitionProcessToTweetDetail(homeTimeline: data)
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
                self?.homeViewModel.transitionProcessToProfile(homeTimeline: data)
            })
            .disposed(by: disposeBag)
    }
    //ツイート詳細遷移
    private func transitionToTweetDetail() {
        homeViewModel.tweetDetailData
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
        homeViewModel.screenName
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
    //ツイート投稿画面遷移
    private func plusButtonImageTapped() {
        let tapGesture = UITapGestureRecognizer()
        plusButtonImage.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: {[weak self] _ in
                let createTweetStoryboard = UIStoryboard(name: "CreateTweet", bundle: nil)
                guard let createTweetViewController = createTweetStoryboard.instantiateViewController(withIdentifier: "createTweet") as? CreateTweetViewController else {
                    fatalError("Storyboard named \"CreateTweet\" does NOT exists.")
                }
                createTweetViewController.delegate = self
                self?.present(createTweetViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    //dismiss
    @IBAction func cancelTapped(segue: UIStoryboardSegue) {
    }
}

extension HomeViewController: CreateTweetViewControllerDelegate {
    public func dismissCreateView(_ viewController: CreateTweetViewController) {
        dismiss(animated: true, completion: nil)
        homeViewModel.requestHomeTimeline()
    }
}
