//
//  SearchResult.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/27.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct SearchResult {
    public let name: String //ツイートした人の名前
    public let screenName: String //ID　＠〜
    public let profileImageUrl: String  //プロフ画像URL
    public let text: String //ツイート文
    public let createdAt: Date //ツイート日時
    public let mediaUrl: [String]? //投稿した写真URL
    public let mediaType: [MediaType]? //写真か動画か選択
    public let retweetCount: Int //リツイート数
    public let favoriteCount: Int //ファボ数
    public let isRetweeted: Bool //リツイートしたか？
    public let isFavorited: Bool //ファボしたか？
    public let verified: Bool //認証済み有無
    public let source: String //ツイートしたアプリ名
    public let inReplyToStatusIdStr: String? //リプライ元のツイートID
    public let inReplyToScreenName: String? //リプライ先の名前
}

public extension SearchResult {
    init(searchData: JSON) {
        //ツイート情報
        guard let name = searchData["user"]["name"].string else {
            fatalError("name is missing")
        }
        guard let screenName = searchData["user"]["screen_name"].string else {
            fatalError("screen_name is missing")
        }
        guard let profileImageUrl = searchData["user"]["profile_image_url_https"].string else {
            fatalError("profile_image_url_httpsis missing")
        }
        guard let text = searchData["text"].string else {
            fatalError("text missing")
        }
        guard let createdAt = searchData["created_at"].string else {
            fatalError("created_at missing")
        }
        guard let createdAtFormatted = Date(fromISO8601: createdAt) else {
            fatalError("createdAt can not be formatted")
        }
        self.name = name
        self.screenName = screenName
        self.profileImageUrl = profileImageUrl
        self.text = text
        self.createdAt = createdAtFormatted
        
        if !searchData["extended_entities"]["media"].isEmpty {
            let media = searchData["extended_entities"]["media"]
            let mediaUrl = media.compactMap { $0.1["media_url_https"].string }
            let mediaType:[MediaType] = media.compactMap {
                switch $0.1["type"].string {
                case "photo":
                    return .photo
                case "movie":
                    return .movie
                default:
                    return nil
                }
            }
            self.mediaUrl = mediaUrl
            self.mediaType = mediaType
        } else {
            self.mediaUrl = nil
            self.mediaType = nil
        }
        //一般情報
        guard let retweetCount = searchData["retweet_count"].int else {
            fatalError("retweet_count is missing")
        }
        guard let favoriteCount = searchData["favorite_count"].int else {
            fatalError("favorite_count is missing")
        }
        guard let isRetweeted = searchData["retweeted"].bool else {
            fatalError("retweeted is missing")
        }
        guard let isFavorited = searchData["favorited"].bool else {
            fatalError("favorited is missing")
        }
        guard let verified = searchData["user"]["verified"].bool else {
            fatalError("verified is missing")
        }
        guard let source = searchData["source"].string else {
            fatalError("source is missing")
        }
        
        self.retweetCount = retweetCount
        self.favoriteCount = favoriteCount
        self.isRetweeted = isRetweeted
        self.isFavorited = isFavorited
        self.verified = verified
        
        if let firstIndex = source.firstIndex(of: ">") {
            let index1 = source.index(after: firstIndex)
            let subString = source.suffix(from: index1)
            let index2 = subString.firstIndex(of: "<")
            if let index2 = index2 {
                self.source = String(source[index1..<index2])
            } else {
                self.source = source
            }
        } else {
            self.source = source
        }
        
        if let inReplyToStatusIdStr = searchData["in_reply_to_status_id_str"].string {
            self.inReplyToStatusIdStr = inReplyToStatusIdStr
        } else {
            self.inReplyToStatusIdStr = nil
        }
        if let inReplyToScreenName = searchData["in_reply_to_screen_name"].string {
            self.inReplyToScreenName = inReplyToScreenName
        } else {
            self.inReplyToScreenName = nil
        }
    }
}

public extension SearchResult {
    init(forTest data: [String:String]) {
        self.name = ""
        self.screenName = data["screenName"]!
        self.profileImageUrl = ""
        self.text = ""
        self.createdAt = Date()
        self.mediaUrl = nil
        self.mediaType = nil
        self.retweetCount = 0
        self.favoriteCount = 0
        self.isRetweeted = false
        self.isFavorited = false
        self.verified = false
        self.source = ""
        self.inReplyToStatusIdStr = data["inReplyToStatusIdStr"]
        self.inReplyToScreenName = data["inReplyToScreenName"]
    }
}
