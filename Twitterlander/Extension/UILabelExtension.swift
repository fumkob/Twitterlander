//
//  UILabelExtension.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/29.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

extension String {

    func makeSize(width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = self.boundingRect(with: bounds, options: options, attributes: attributes, context: nil)
        let size = CGSize(width: rect.size.width, height: ceil(rect.size.height))
        return size
    }
}

extension UILabel {

    func getTextHeight() -> CGFloat {
        guard let text = self.text else {
            return 0.0
        }
        let attributes: [NSAttributedString.Key: Any] = [.font : self.font!]
        let size = text.makeSize(width: self.bounds.width, attributes: attributes)
        return size.height
    }

    func getAttributedTextHeight() -> CGFloat {
        guard let attributedText = self.attributedText else {
            return 0.0
        }
        var attributes: [NSAttributedString.Key: Any] = attributedText.attributes(at: 0, effectiveRange: nil)
        attributes[.font] = self.font
        let size = attributedText.string.makeSize(width: self.bounds.width, attributes: attributes)
        return size.height
    }
}
