//
//  MediaDetailViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/03.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class MediaDetailViewController: UIViewController, SwipeBackable {
    
    @IBOutlet weak var mediaScrollView: UIScrollView!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    private var mediaDetailViewModel: MediaDetailViewModel!
    public var mediaUrl: [URL?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        navigationBarSetup()
        mediaDetailViewSetup()
        imageSetup()
        scrollViewSetup()
        updateContentInset()
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
    }
    
    private func mediaDetailViewSetup() {
        self.mediaDetailViewModel = MediaDetailViewModel()
    }
    
    private func imageSetup() {
        mediaImageView.kf.indicatorType = .activity
        mediaDetailViewModel.row
            .drive(onNext: {[weak self] row in
                self?.mediaImageView.kf.setImage(with: self?.mediaUrl[row])
            })
            .disposed(by: disposeBag)
        mediaDetailViewModel.transferMediaUrl()
    }
    
    private func scrollViewSetup() {
        mediaScrollView.delegate = self
        
        if let image = mediaImageView.image {
            let widthScale = mediaScrollView.bounds.width / image.size.width
            let heightScale = mediaScrollView.bounds.height / image.size.height
            let scale = min(widthScale, heightScale)
            
            mediaScrollView.minimumZoomScale = scale
            mediaScrollView.maximumZoomScale = scale * 5
            
            // After setting minimumZoomScale, maximumZoomScale and delegate.
            mediaScrollView.zoomScale = mediaScrollView.minimumZoomScale
            mediaScrollView.addSubview(mediaImageView)
            
        }
    }
    
}

extension MediaDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mediaImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContentInset()
    }
    func updateContentInset() {
        let widthInset = max((mediaScrollView.frame.width - mediaImageView.frame.width) / 2, 0)
        let heightInset = max((mediaScrollView.frame.height - mediaImageView.frame.height) / 2, 0)
        
        print(widthInset)
        print(heightInset)
        mediaScrollView.contentInset = .init(top: widthInset,
                                        left: heightInset,
                                        bottom: widthInset,
                                        right: heightInset)
    }
}
