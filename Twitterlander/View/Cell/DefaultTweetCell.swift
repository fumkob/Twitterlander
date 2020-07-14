//
//  DefaultTweetCell.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/16.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import Kingfisher

class DefaultTweetCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var media1: UIImageView!
    @IBOutlet weak var media2: UIImageView!
    @IBOutlet weak var media3: UIImageView!
    @IBOutlet weak var media4: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweetSymbol: UIImageView!
    
    @IBOutlet weak var constraintWithVerification: NSLayoutConstraint!
    @IBOutlet weak var constraintWithoutVerification: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageToMedia1: NSLayoutConstraint!
    @IBOutlet weak var tweetTextToMedia1: NSLayoutConstraint!
    @IBOutlet weak var media1HeightHalf: NSLayoutConstraint!
    @IBOutlet weak var media1HeightFull: NSLayoutConstraint!
    @IBOutlet weak var media1ToTrailing: NSLayoutConstraint!
    @IBOutlet weak var media1ToStackView: NSLayoutConstraint!
    
    @IBOutlet weak var media1ToMedia2: NSLayoutConstraint!
    @IBOutlet weak var media1TopEqualToMedia2Top: NSLayoutConstraint!
    @IBOutlet weak var media1HeightEqualToMedia2Height: NSLayoutConstraint!
    @IBOutlet weak var media1WidthEqualToMedia2Width: NSLayoutConstraint!
    @IBOutlet weak var media2ToTrailing: NSLayoutConstraint!
    @IBOutlet weak var media2HeightHalf: NSLayoutConstraint!
    
    @IBOutlet weak var media1LeadingEqualToMedia3Leading: NSLayoutConstraint!
    @IBOutlet weak var media1WidthEqualToMedia3Width: NSLayoutConstraint!
    @IBOutlet weak var media2HeightEqualToMedia3Height: NSLayoutConstraint!
    @IBOutlet weak var media2ToMedia3: NSLayoutConstraint!
    @IBOutlet weak var media2LeadingEqualToMedia3Leading: NSLayoutConstraint!
    @IBOutlet weak var media3ToStackView: NSLayoutConstraint!
    
    @IBOutlet weak var media1HeightEqualToMedia4Height: NSLayoutConstraint!
    @IBOutlet weak var media1WidthEqualToMedia4Width: NSLayoutConstraint!
    @IBOutlet weak var media2LeadingEqualToMedia4Leading: NSLayoutConstraint!
    @IBOutlet weak var media3TopEqualToMedia4Top: NSLayoutConstraint!
    
    @IBOutlet weak var tweetTextBottomToViewStackTop: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabelToTop: NSLayoutConstraint!
    @IBOutlet weak var retweetLabelToTop: NSLayoutConstraint!
    @IBOutlet weak var retweetLabelToNameLabel: NSLayoutConstraint!
    
    private let timeCalculation = TimeCalculation()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func defaultTweetSetup(data: HomeTimeline) {
        nameLabel.text = data.name
        screenNameLabel.text = "@" + "\(data.screenName)"
        tweetTextLabel.text = data.text
        timeLabel.text = timeCalculation.dateToString(createdAt: data.createdAt)
        replyCountLabel.text = "" //Home_Timeline上には流れてこないため別途集計が必要
        if data.retweetCount == 0 {
            retweetCountLabel.text = ""
        } else {
            retweetCountLabel.text = "\(data.retweetCount)"
        }
        if data.favoriteCount == 0 {
            favoriteCountLabel.text = ""
        } else {
            favoriteCountLabel.text = "\(data.favoriteCount)"
        }
        let url = URL(string: data.profileImageUrl.replacingOccurrences(of: "_normal", with: ""))
        profileImage.kf.indicatorType = .activity
        self.profileImage.kf.setImage(with: url)
        
        switch data.verified {
        case true:
            NSLayoutConstraint.deactivate([constraintWithoutVerification])
            NSLayoutConstraint.activate([constraintWithVerification])
            verifiedImage.isHidden = false
        case false:
            NSLayoutConstraint.deactivate([constraintWithVerification])
            NSLayoutConstraint.activate([constraintWithoutVerification])
            verifiedImage.isHidden = true
        }
        
        media1.isHidden = true
        media2.isHidden = true
        media3.isHidden = true
        media4.isHidden = true
        retweetLabel.isHidden = true
        retweetSymbol.isHidden = true
        
        //レイアウト制約一旦全解除
        constraintReset()
        NSLayoutConstraint.activate([nameLabelToTop])

        if let mediaUrl = data.mediaUrl {
            switch mediaUrl.count {
            case 1:
                constraintWith1Picture(mediaUrl: mediaUrl)
                
            case 2:
                constraintWith2Pictures(mediaUrl: mediaUrl)
                
            case 3:
                constraintWith3Pictures(mediaUrl: mediaUrl)
                
            case 4:
                constraintWith4Pictures(mediaUrl: mediaUrl)
                                
            default :
                fatalError("Unexpected error in count of mediaUrl")
            }
        } else {
            
            NSLayoutConstraint.activate([tweetTextBottomToViewStackTop])
        }
    }
    
    public func retweetSetup(data: HomeTimeline) {
        nameLabel.text = data.retweetedName
        guard let retweetedScreenName = data.retweetedScreenName else { fatalError("retweetedScreenName is nil")}
        screenNameLabel.text = "@" + retweetedScreenName
        tweetTextLabel.text = data.retweetedText
        guard let retweetedCreatedAt = data.retweetedCreatedAt else { fatalError("retweetedCreatedAt is nil")}
        timeLabel.text = timeCalculation.dateToString(createdAt: retweetedCreatedAt)
        replyCountLabel.text = "" //Home_Timeline上には流れてこないため別途集計が必要
        if data.retweetCount == 0 {
            retweetCountLabel.text = ""
        } else {
            retweetCountLabel.text = "\(data.retweetCount)"
        }
        guard let retweetedFavoriteCount = data.retweetedFavoriteCount else { fatalError("retweetedFavoriteCount is nil")}
        if retweetedFavoriteCount == 0 {
            favoriteCountLabel.text = ""
        } else {
            favoriteCountLabel.text = "\(retweetedFavoriteCount)"
        }
        guard let retweetedProfileImageUrl = data.retweetedProfileImageUrl else { fatalError("retweetedProfileImageUrl is nil")}
        let url = URL(string: retweetedProfileImageUrl.replacingOccurrences(of: "_normal", with: ""))
        profileImage.kf.indicatorType = .activity
        self.profileImage.kf.setImage(with: url)
        //リツイート表示
        switch data.isRetweeted {
        case true:
            retweetLabel.text = "リツイート済み"
        case false:
            retweetLabel.text = "\(data.name)さんがリツイート"
        }
        
        switch data.verified {
        case true:
            NSLayoutConstraint.deactivate([constraintWithoutVerification])
            NSLayoutConstraint.activate([constraintWithVerification])
            verifiedImage.isHidden = false
        case false:
            NSLayoutConstraint.deactivate([constraintWithVerification])
            NSLayoutConstraint.activate([constraintWithoutVerification])
            verifiedImage.isHidden = true
        }
        
        media1.isHidden = true
        media2.isHidden = true
        media3.isHidden = true
        media4.isHidden = true
        retweetLabel.isHidden = false
        retweetSymbol.isHidden = false
        
        //レイアウト制約一旦全解除
        constraintReset()
        NSLayoutConstraint.activate([retweetLabelToTop])
        NSLayoutConstraint.activate([retweetLabelToNameLabel])
        
        if let mediaUrl = data.retweetedMediaUrl {
            switch mediaUrl.count {
            case 1:
                constraintWith1Picture(mediaUrl: mediaUrl)
                
            case 2:
                constraintWith2Pictures(mediaUrl: mediaUrl)
                
            case 3:
                constraintWith3Pictures(mediaUrl: mediaUrl)
                
            case 4:
                constraintWith4Pictures(mediaUrl: mediaUrl)
                                
            default :
                fatalError("Unexpected error in count of mediaUrl")
            }
        } else {
            NSLayoutConstraint.activate([tweetTextBottomToViewStackTop])
        }
    }
    
    private func constraintReset() {
        NSLayoutConstraint.deactivate([profileImageToMedia1])
        NSLayoutConstraint.deactivate([tweetTextToMedia1])
        NSLayoutConstraint.deactivate([media1HeightHalf])
        NSLayoutConstraint.deactivate([media1HeightFull])
        NSLayoutConstraint.deactivate([media1ToTrailing])
        NSLayoutConstraint.deactivate([media1ToStackView])
        
        NSLayoutConstraint.deactivate([media1ToMedia2])
        NSLayoutConstraint.deactivate([media1TopEqualToMedia2Top])
        NSLayoutConstraint.deactivate([media1HeightEqualToMedia2Height])
        NSLayoutConstraint.deactivate([media1WidthEqualToMedia2Width])
        NSLayoutConstraint.deactivate([media2ToTrailing])
        NSLayoutConstraint.deactivate([media2HeightHalf])
        
        NSLayoutConstraint.deactivate([media1LeadingEqualToMedia3Leading])
        NSLayoutConstraint.deactivate([media1WidthEqualToMedia3Width])
        NSLayoutConstraint.deactivate([media2HeightEqualToMedia3Height])
        NSLayoutConstraint.deactivate([media2ToMedia3])
        NSLayoutConstraint.deactivate([media2LeadingEqualToMedia3Leading])
        NSLayoutConstraint.deactivate([media3ToStackView])
        
        NSLayoutConstraint.deactivate([media1HeightEqualToMedia4Height])
        NSLayoutConstraint.deactivate([media1WidthEqualToMedia4Width])
        NSLayoutConstraint.deactivate([media2LeadingEqualToMedia4Leading])
        NSLayoutConstraint.deactivate([media3TopEqualToMedia4Top])
        
        NSLayoutConstraint.deactivate([tweetTextBottomToViewStackTop])
        
        NSLayoutConstraint.deactivate([retweetLabelToTop])
        NSLayoutConstraint.deactivate([retweetLabelToNameLabel])
        NSLayoutConstraint.deactivate([nameLabelToTop])
    }

    private func constraintWith1Picture(mediaUrl: [String]) {
        let url = URL(string: mediaUrl[0])
        media1.kf.indicatorType = .activity
        self.media1.kf.setImage(with: url)
        
        media1.isHidden = false
        
        NSLayoutConstraint.activate([profileImageToMedia1])
        NSLayoutConstraint.activate([tweetTextToMedia1])
        NSLayoutConstraint.activate([media1HeightFull])
        NSLayoutConstraint.activate([media1ToTrailing])
        NSLayoutConstraint.activate([media1ToStackView])
    }
    
    private func constraintWith2Pictures(mediaUrl: [String]) {
        let url = URL(string: mediaUrl[0])
        media1.kf.indicatorType = .activity
        self.media1.kf.setImage(with: url)
        let url2 = URL(string: mediaUrl[1])
        media2.kf.indicatorType = .activity
        self.media2.kf.setImage(with: url2)
        
        media1.isHidden = false
        media2.isHidden = false
        
        NSLayoutConstraint.activate([profileImageToMedia1])
        NSLayoutConstraint.activate([tweetTextToMedia1])
        NSLayoutConstraint.activate([media1HeightFull])
        NSLayoutConstraint.activate([media1ToStackView])
        
        NSLayoutConstraint.activate([media1ToMedia2])
        NSLayoutConstraint.activate([media1TopEqualToMedia2Top])
        NSLayoutConstraint.activate([media1HeightEqualToMedia2Height])
        NSLayoutConstraint.activate([media1WidthEqualToMedia2Width])
        NSLayoutConstraint.activate([media2ToTrailing])
    }
    
    private func constraintWith3Pictures(mediaUrl: [String]) {
        let url = URL(string: mediaUrl[0])
        media1.kf.indicatorType = .activity
        self.media1.kf.setImage(with: url)
        let url2 = URL(string: mediaUrl[1])
        media2.kf.indicatorType = .activity
        self.media2.kf.setImage(with: url2)
        let url3 = URL(string: mediaUrl[2])
        media3.kf.indicatorType = .activity
        self.media3.kf.setImage(with: url3)
        
        media1.isHidden = false
        media2.isHidden = false
        media3.isHidden = false
        
        NSLayoutConstraint.activate([profileImageToMedia1])
        NSLayoutConstraint.activate([tweetTextToMedia1])
        NSLayoutConstraint.activate([media1ToStackView])
        
        NSLayoutConstraint.activate([media1ToMedia2])
        NSLayoutConstraint.activate([media1TopEqualToMedia2Top])
        NSLayoutConstraint.activate([media1WidthEqualToMedia2Width])
        NSLayoutConstraint.activate([media2ToTrailing])
        NSLayoutConstraint.activate([media2HeightHalf])
        
        NSLayoutConstraint.activate([media1WidthEqualToMedia3Width])
        NSLayoutConstraint.activate([media2HeightEqualToMedia3Height])
        NSLayoutConstraint.activate([media2ToMedia3])
        NSLayoutConstraint.activate([media2LeadingEqualToMedia3Leading])
        NSLayoutConstraint.activate([media3ToStackView])
    }
    
    private func constraintWith4Pictures(mediaUrl: [String]) {
        let url = URL(string: mediaUrl[0])
        media1.kf.indicatorType = .activity
        self.media1.kf.setImage(with: url)
        let url2 = URL(string: mediaUrl[1])
        media2.kf.indicatorType = .activity
        self.media2.kf.setImage(with: url2)
        let url3 = URL(string: mediaUrl[2])
        media3.kf.indicatorType = .activity
        self.media3.kf.setImage(with: url3)
        let url4 = URL(string: mediaUrl[3])
        media4.kf.indicatorType = .activity
        self.media4.kf.setImage(with: url4)
        
        media1.isHidden = false
        media2.isHidden = false
        media3.isHidden = false
        media4.isHidden = false
        
        NSLayoutConstraint.activate([profileImageToMedia1])
        NSLayoutConstraint.activate([tweetTextToMedia1])
        NSLayoutConstraint.activate([media1HeightHalf])
        
        NSLayoutConstraint.activate([media1ToMedia2])
        NSLayoutConstraint.activate([media1TopEqualToMedia2Top])
        NSLayoutConstraint.activate([media1HeightEqualToMedia2Height])
        NSLayoutConstraint.activate([media1WidthEqualToMedia2Width])
        NSLayoutConstraint.activate([media2ToTrailing])
        
        NSLayoutConstraint.activate([media1LeadingEqualToMedia3Leading])
        NSLayoutConstraint.activate([media1WidthEqualToMedia3Width])
        NSLayoutConstraint.activate([media2HeightEqualToMedia3Height])
        NSLayoutConstraint.activate([media2ToMedia3])
        NSLayoutConstraint.activate([media3ToStackView])
        
        NSLayoutConstraint.activate([media1HeightEqualToMedia4Height])
        NSLayoutConstraint.activate([media1WidthEqualToMedia4Width])
        NSLayoutConstraint.activate([media2LeadingEqualToMedia4Leading])
        NSLayoutConstraint.activate([media3TopEqualToMedia4Top])
    }
}
