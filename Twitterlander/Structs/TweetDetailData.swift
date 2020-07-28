//
//  TweetDetailData.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/24.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

public struct TweetDetailData {
    public let name: String //ツイートした人の名前
    public let screenName: String //ID　＠〜
    public let profileImageUrl: String  //プロフ画像URL
    public let text: String //ツイート文
    public let idStr: String //ツイートID
    public let createdAt: Date //ツイート日時
    public let mediaUrl: [String]? //投稿した写真URL
    public let mediaType: [MediaType]? //写真か動画か選択public let retweetCount: Int //リツイート数
    public let retweetCount: Int //リツイート数
    public let favoriteCount: Int //ファボ数
    public let isRetweeted: Bool //リツイートしたか？
    public let isFavorited: Bool //ファボしたか？
    public let verified: Bool //認証済み有無
    public let source: String //ツイートしたアプリ名
}

public extension TweetDetailData {
    init(normalTweet homeTimeline: HomeTimeline) {
        self.name = homeTimeline.name
        self.screenName = homeTimeline.screenName
        self.profileImageUrl = homeTimeline.profileImageUrl
        self.text = homeTimeline.text
        self.idStr = homeTimeline.idStr
        self.createdAt = homeTimeline.createdAt
        self.mediaUrl = homeTimeline.mediaUrl
        self.mediaType = homeTimeline.mediaType
        self.retweetCount = homeTimeline.retweetCount
        self.favoriteCount = homeTimeline.favoriteCount
        self.isRetweeted = homeTimeline.isRetweeted
        self.isFavorited = homeTimeline.isFavorited
        self.verified = homeTimeline.verified
        self.source = homeTimeline.source
    }
    
    init(retweet homeTimeline: HomeTimeline) {
        guard let retweetedName = homeTimeline.retweetedName else {
            fatalError("retweetedName is nil")
        }
        guard let retweetedScreenName = homeTimeline.retweetedScreenName else {
            fatalError("retweetedScreenName is nil")
        }
        guard let retweetedProfileImageUrl = homeTimeline.retweetedProfileImageUrl else {
            fatalError("retweetedProfileImage is nil")
        }
        guard let retweetedText = homeTimeline.retweetedText else {
            fatalError("retweetedText is nil")
        }
        guard let retweetedIdStr = homeTimeline.retweetedIdStr else {
            fatalError("retweetedIdStr is nil")
        }
        guard let retweetedCreatedAt = homeTimeline.retweetedCreatedAt else {
            fatalError("retweetedCreatedAt is nil")
        }
        guard let retweetedFavoriteCount = homeTimeline.retweetedFavoriteCount else {
            fatalError("retweetedProfileImage is nil")
        }
        guard let retweetedSource = homeTimeline.retweetedSource else {
            fatalError("retweetedProfileImage is nil")
        }
        self.name = retweetedName
        self.screenName = retweetedScreenName
        self.profileImageUrl = retweetedProfileImageUrl
        self.text = retweetedText
        self.idStr = retweetedIdStr
        self.createdAt = retweetedCreatedAt
        self.mediaUrl = homeTimeline.retweetedMediaUrl
        self.mediaType = homeTimeline.retweetedMediaType
        self.favoriteCount = retweetedFavoriteCount
        self.retweetCount = homeTimeline.retweetCount
        self.isRetweeted = homeTimeline.isRetweeted
        self.isFavorited = homeTimeline.isFavorited
        self.verified = homeTimeline.verified
        self.source = retweetedSource
    }
    
    init(forTest data: [String:String]) {
        self.name = ""
        self.screenName = data["screenName"]!
        self.profileImageUrl = ""
        self.text = ""
        self.idStr = data["idStr"]!
        self.createdAt = Date()
        self.mediaUrl = nil
        self.mediaType = nil
        self.favoriteCount = 0
        self.retweetCount = 0
        self.isRetweeted = false
        self.isFavorited = false
        self.verified = false
        self.source = ""
    }
}
