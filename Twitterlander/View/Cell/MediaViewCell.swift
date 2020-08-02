//
//  MediaViewCell.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/03.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import Kingfisher

class MediaViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    public func imageSetup(url: URL?) {
        mediaImageView.kf.indicatorType = .activity
        mediaImageView.kf.setImage(with: url)
    }
}
