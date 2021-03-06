//
//  ProfileContentsViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/30.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import RxSwift
import RxCocoa

class ProfileContentsViewController: TabmanViewController {
    public var screenName: String!
    
    private lazy var viewControllers: [UIViewController] = {
        [
            ProfileTweetViewController.makeInstance(screenName: screenName),
            ProfileMediaViewController.makeInstance(screenName: screenName)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileContents ViewDidLoad")
        
        dataSource = self
        barSetup()
        
    }
    
    private func barSetup() {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        bar.layout.alignment = .centerDistributed
        bar.backgroundView.style = .clear
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                        didScrollToPageAt index: PageboyViewController.PageIndex,
                                        direction: PageboyViewController.NavigationDirection,
                                        animated: Bool) {
        super.pageboyViewController(pageboyViewController,
                                    didScrollToPageAt: index,
                                    direction: direction,
                                    animated: animated)
        
        print("didScrollToPageAtIndex: \(index)")
        ProfileViewInfo.shared.receiveIndex.onNext(index)
    }
}

extension ProfileContentsViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let titles = ["ツイート", "メディア"]
        return TMBarItem(title: titles[index])
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

extension ProfileContentsViewController {
    static func makeInstance(screenName: String) -> ProfileContentsViewController {
        let storyboard = UIStoryboard(name: "ProfileContents", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "profileContents") as? ProfileContentsViewController else {
            fatalError("Storyboard named \"Profile\" does NOT exists.")
        }
        controller.screenName = screenName
        return controller
    }
}
