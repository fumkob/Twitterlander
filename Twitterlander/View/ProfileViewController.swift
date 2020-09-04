//
//  ProfileViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/22.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ProfileViewController: UIViewController, SwipeBackable {
    
    @IBOutlet weak var headerViewContainer: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    @IBOutlet weak var followButton: CustomButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLinkStackView: UIStackView!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var linkStackView: UIStackView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var followNumberLabel: UILabel!
    @IBOutlet weak var followerNumberLabel: UILabel!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    public var profileContentsViewController: ProfileContentsViewController!
    private var profileViewModel: ProfileViewModel!
    private let disposeBag = DisposeBag()
    private var screenName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Profile ViewDidLoad")
        setSwipeBack()
        profileViewSetup()
        navigationBarSetup()
        profileSetup()
        viewHeightSetup()
        profileContentsViewSetup(controller: profileContentsViewController)
    }
    
    //ViewModel設定
    private func profileViewSetup() {
        profileViewModel = ProfileViewModel(client: ProfileClient(), screenName: screenName)
    }
    //ナビゲーションバー設定
    private func navigationBarSetup() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        navigationItem.standardAppearance = appearance
        
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance?.buttonAppearance = buttonAppearance
        
        self.navigationController!.navigationBar.tintColor = .white
        
        visualEffectView.alpha = 0
        titleNameLabel.alpha = 0
        
        scrollView.rx.contentOffset
            .subscribe(onNext: {[unowned self] in
                let alpha = self.calculateAlpha(yLocatioin: $0.y)
                self.visualEffectView.alpha = alpha
                self.titleNameLabel.alpha = alpha
            })
            .disposed(by: disposeBag)
    }
    
    //プロフィール欄設定
    private func profileSetup() {
        profileView.isHidden = true
        profileViewModel.getProfile(screenName: screenName)
        profileViewModel.profileData
            .drive(onNext: { [weak self] data in
                self?.profileDetailSetup(data: data)
            })
            .disposed(by: disposeBag)
    }
    private func profileDetailSetup(data: ProfileData) {
        profileView.isHidden  = false
        //画像設定
        if let urlString = data.profileBannerUrl {
            let bannerUrl = URL(string: urlString)
            headerImage.kf.indicatorType = .activity
            headerImage.kf.setImage(with: bannerUrl)
        } else {
            headerImage.image = UIImage(named: "EmptyBanner")
            headerViewContainer.backgroundColor = .systemBlue
        }
        let profileImageUrl = URL(string: data.profileImageUrl.replacingOccurrences(of: "_normal", with: ""))
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: profileImageUrl)
        //text設定
        titleNameLabel.text = data.name
        nameLabel.text = data.name
        screenNameLabel.text = "@" + data.screenName
        descriptionLabel.text = data.description
        beginDateLabel.text = data.createdAt.profileDateStyle() + "からTwitterを利用しています"
        followNumberLabel.text = String(data.friendsCount)
        followerNumberLabel.text = String(data.followersCount)
        //フォローボタン
        if data.following {
            followButton.setTitleColor(.white, for: .normal)
            followButton.setTitle("フォロー中", for: .normal)
            followButton.backgroundColor = .link
            followButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
            followButton.isEnabled = false
        } else {
            followButton.setTitle("フォローする", for: .normal)
        }
        //非表示系
        if data.verified {
            verifiedImage.isHidden = false
        }
        if !data.location.isEmpty || data.link != nil {
            locationLinkStackView.isHidden = false
            if !data.location.isEmpty {
                locationStackView.isHidden = false
                locationLabel.text = data.location
            }
            if let link = data.link {
                linkStackView.isHidden = false
                linkButton.setTitle(link[0], for: .normal)
            }
        }
    }
    //ビュー高さ設定
    private func viewHeightSetup() {
        profileViewModel.transferViewHeight()
        profileViewModel.viewHeight
            .drive(onNext: { [weak self] in
                self?.containerViewHeight.constant = $0
            })
            .disposed(by: disposeBag)
    }
    
    //alpha値計算
    public func calculateAlpha(yLocatioin: CGFloat) -> CGFloat {
        var alpha = 1 - (yLocatioin / -64)
        if alpha > 1 {
            alpha = 1
        } else if alpha < 0 {
            alpha = 0
        }
        return alpha
    }
    
    //ProfileContentsViewセットアップ
    private func profileContentsViewSetup(controller: ProfileContentsViewController) {
        addChild(controller)
        controller.view.frame = containerView.bounds
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}

extension ProfileViewController {
    static func makeInstance(screenName:String) -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "profile") as? ProfileViewController else {
            fatalError("Storyboard named \"Profile\" does NOT exists.")
        }
        let profileContentsViewController = ProfileContentsViewController.makeInstance(screenName: screenName)
        controller.screenName = screenName
        controller.profileContentsViewController = profileContentsViewController
        return controller
    }
}
