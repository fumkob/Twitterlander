//
//  ProfileMediaViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/30.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileMediaViewController: UIViewController {
    
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private var profileMediaViewModel: ProfileMediaViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileMedia ViewDidLoad")
        mediaCollectionView.delegate = self
        
        mediaSetup()
        heightSetup()
        transitionToMediaDetail()
        cellTapped()
    }
    
    //View Modelセット
    private func profileMediaViewSetup(screenName: String) {
        self.profileMediaViewModel = ProfileMediaViewModel(client: TimelineClient(), screenName: screenName)
    }
    //画像セット
    private func mediaSetup() {
        profileMediaViewModel.requestMediaInfo()
        profileMediaViewModel.mediaUrlArray
            .drive(mediaCollectionView.rx.items(cellIdentifier: "collectionCell", cellType: MediaViewCell.self)) {_, element, cell in
                cell.imageSetup(url: element)
        }
        .disposed(by: disposeBag)
    }
    //ビュー高さ設定
    private func heightSetup() {
        //Collection View高さ受け渡し
        mediaCollectionView.rx.observe(CGSize.self, "contentSize")
        .subscribe(onNext: { [weak self] size in
            if let size = size {
                self?.profileMediaViewModel.postContentsHeight(height: size.height)
            }
        })
        .disposed(by: disposeBag)
    }
    //遷移処理
    private func transitionToMediaDetail() {
        profileMediaViewModel.mediaUrlTransition
            .drive(onNext: {[weak self] url in
                let mediaDetailStoryboard = UIStoryboard(name: "MediaDetail", bundle: nil)
                guard let mediaDetailViewController = mediaDetailStoryboard.instantiateViewController(withIdentifier: "mediaDetail") as? MediaDetailViewController else {
                    fatalError("Storyboard named \"MediaDetail\" does NOT exists.")
                }
                mediaDetailViewController.mediaUrl = url
                self?.navigationController?.pushViewController(mediaDetailViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    //Cellタップ処理
    private func cellTapped() {
        mediaCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.profileMediaViewModel.transitionProcessToMediaDetail(row: indexPath.row)
            })
        .disposed(by: disposeBag)
    }
}

extension ProfileMediaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 横方向のスペース調整
        let cellSize:CGFloat = self.view.bounds.width/3 - 1
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
}

extension ProfileMediaViewController {
    static func makeInstance(screenName: String) -> ProfileMediaViewController {
        guard let controller = UIStoryboard(name: "ProfileMedia", bundle: nil).instantiateViewController(withIdentifier: "profileMedia") as? ProfileMediaViewController else {fatalError("invalid controller")}
        controller.profileMediaViewSetup(screenName: screenName)
        return controller
    }
}
