//
//  CircleImageView.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/13.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//
//  This source code was quoted from https://qiita.com/saku/items/29c7fa20a62cc2f366fa

import UIKit

open class CircleImageView: UIImageView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // swap UIImage because you can't asign yourself.
        let image = self.image
        self.image = image
    }
    
    open override var image: UIImage? {
        get { return super.image }
        set {
            self.contentMode = .scaleAspectFit
            super.image = newValue?.roundImage()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2.0
    }
}

extension UIImage {
    func roundImage() -> UIImage {
        let minLength: CGFloat = min(self.size.width, self.size.height)
        let rectangleSize: CGSize = CGSize(width: minLength, height: minLength)
        UIGraphicsBeginImageContextWithOptions(rectangleSize, false, 0.0)
        
        UIBezierPath(roundedRect: CGRect(origin: .zero, size: rectangleSize), cornerRadius: minLength).addClip()
        self.draw(in: CGRect(origin: CGPoint(x: (minLength - self.size.width) / 2, y: (minLength - self.size.height) / 2), size: self.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
