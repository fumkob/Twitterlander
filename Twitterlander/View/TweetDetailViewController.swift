//
//  TweetDetailViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/22.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class TweetDetailViewController: UIViewController, SwipeBackable {
    
    public var tweetDetailData: TweetDetailData!
    private var tweetDetailViewModel: TweetDetailViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tweetDetailView: UIView!
    @IBOutlet weak var profileImage: CircleImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var allMediaStackView: UIStackView!
    @IBOutlet weak var allMediaStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var leftSideMediaStackView: UIStackView!
    @IBOutlet weak var rightSideMediaStackView: UIStackView!
    @IBOutlet weak var media1: UIImageView!
    @IBOutlet weak var media2: UIImageView!
    @IBOutlet weak var media3: UIImageView!
    @IBOutlet weak var media4: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var numbersView: UIView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetTextLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteTextLabel: UILabel!
    @IBOutlet weak var spaceLabel: UILabel!
    @IBOutlet weak var stackViewForLine: UIStackView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        tweetDetailViewSetup()
        activityIndicatorSetup()
        navigationBarSetup()
        tableSetup()
        generalInformationSetup()
        mediaSetup()
        numbersSetup()
        tweetDetailProfileImageTapped()
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    //View Model指定
    private func tweetDetailViewSetup() {
        tweetDetailViewModel = TweetDetailViewModel(client: SearchClient())
    }
    
    private func activityIndicatorSetup() {
        activityIndicator.hidesWhenStopped = true
        let activityIndicatorStatus = tweetDetailViewModel.activityindicatorStatus
        activityIndicatorStatus
            .drive(self.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    //ナビゲーションバー設定
    private func navigationBarSetup() {
        self.navigationItem.title = "ツイート"
    }
    
    private func tableSetup() {
        tableView.register(UINib(nibName: "DefaultTweetCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
        //リプライを検索
        tweetDetailViewModel.getReplies(tweetDetailData: tweetDetailData)
        //データをセル格納
        let searchResult = tweetDetailViewModel.searchResult
        searchResult
            .drive(tableView.rx.items) {[weak self] tableView, _, data in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as? DefaultTweetCell else {
                    fatalError("cell is nil")
                }
                cell.replySetup(data: data)
                self?.replyProfileImageTapped(cell: cell)
                return cell
        }
        .disposed(by: disposeBag)
    }
    
    private func generalInformationSetup() {
        nameLabel.text = tweetDetailData.name
        screenNameLabel.text = "@" + tweetDetailData.screenName
        tweetTextLabel.text = tweetDetailData.text
        timeLabel.text = tweetDetailData.createdAt.twitterTimeStyle()
        dateLabel.text = "・" + tweetDetailData.createdAt.twitterDateStyle() + "・"
        sourceLabel.text = tweetDetailData.source
        //画像設定
        let url = URL(string: tweetDetailData.profileImageUrl.replacingOccurrences(of: "_normal", with: ""))
        profileImage.kf.indicatorType = .activity
        self.profileImage.kf.setImage(with: url)
        //認証マーク有無
        switch tweetDetailData.verified {
        case true:
            verifiedImage.isHidden = false
        case false:
            verifiedImage.isHidden = true
        }
    }
    //画像設定
    private func mediaSetup() {
        if let mediaUrl = tweetDetailData.mediaUrl {
            switch mediaUrl.count {
            case 1:
                rightSideMediaStackView.isHidden = true
                media3.isHidden = true
                firstPictureSetup(mediaUrl: mediaUrl)
            case 2:
                media3.isHidden = true
                media4.isHidden = true
                secondPictureSetup(mediaUrl: mediaUrl)
            case 3:
                media3.isHidden = true
                thirdPictureSetup(mediaUrl: mediaUrl)
            case 4:
                forthPictureSetup(mediaUrl: mediaUrl)
            default:
                fatalError("Unexpected error of media count")
            }
        } else {
            allMediaStackView.isHidden = true
            allMediaStackViewHeight.constant = 0	
        }
    }
    
    private func firstPictureSetup(mediaUrl: [String]) {
        let url = URL(string: mediaUrl[0])
        media1.kf.indicatorType = .activity
        self.media1.kf.setImage(with: url)
    }
    private func secondPictureSetup(mediaUrl: [String]) {
        firstPictureSetup(mediaUrl: mediaUrl)
        let url = URL(string: mediaUrl[1])
        media2.kf.indicatorType = .activity
        self.media2.kf.setImage(with: url)
    }
    private func thirdPictureSetup(mediaUrl: [String]) {
        secondPictureSetup(mediaUrl: mediaUrl)
        let url = URL(string: mediaUrl[2])
        media4.kf.indicatorType = .activity
        self.media4.kf.setImage(with: url)
    }
    private func forthPictureSetup(mediaUrl: [String]) {
        secondPictureSetup(mediaUrl: mediaUrl)
        let url = URL(string: mediaUrl[2])
        media3.kf.indicatorType = .activity
        self.media3.kf.setImage(with: url)
        let url2 = URL(string: mediaUrl[3])
        media4.kf.indicatorType = .activity
        self.media4.kf.setImage(with: url2)
    }
    //リツイート、ファボ数View設定
    private func numbersSetup() {
        retweetCountLabel.text = "\(tweetDetailData.retweetCount)"
        favoriteCountLabel.text = "\(tweetDetailData.favoriteCount)"
        if tweetDetailData.retweetCount == 0 && tweetDetailData.favoriteCount == 0 {
            numbersView.isHidden = true
            stackViewForLine.isHidden = true
        } else if tweetDetailData.retweetCount == 0 {
            retweetCountLabel.isHidden = true
            retweetTextLabel.isHidden = true
            spaceLabel.isHidden = true
        } else if tweetDetailData.favoriteCount == 0 {
            favoriteCountLabel.isHidden = true
            favoriteTextLabel.isHidden = true
            spaceLabel.isHidden = true
        }
    }
    //プロフィール画像タップ時処理
    private func tweetDetailProfileImageTapped() {
        let detailImageTapGesture = UITapGestureRecognizer()
        profileImage.addGestureRecognizer(detailImageTapGesture)
        detailImageTapGesture.rx.event
            .subscribe(onNext: {[weak self] _ in
                self?.transitionToProfile()
            })
            .disposed(by: disposeBag)
    }
    //リプライプロフィール画像タップ時処理
    private func replyProfileImageTapped(cell: DefaultTweetCell) {
        let replyImageTapGesture = UITapGestureRecognizer()
        cell.profileImage.addGestureRecognizer(replyImageTapGesture)
        replyImageTapGesture.rx.event
            .subscribe(onNext: {[weak self] _ in
                self?.transitionToProfile()
            })
            .disposed(by: disposeBag)
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
