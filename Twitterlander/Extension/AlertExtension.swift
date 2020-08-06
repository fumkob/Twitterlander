//
//  AlertExtension.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/05.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func okAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: handler)
        alert.addAction(okAction)
        return alert
    }
}
