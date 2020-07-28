//
//  SwipeBackable.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/25.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

protocol SwipeBackable {
    func setSwipeBack()
}

extension SwipeBackable where Self: UIViewController {
    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}
