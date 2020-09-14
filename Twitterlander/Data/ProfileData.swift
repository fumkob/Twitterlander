//
//  ProfileData.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/31.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ProfileData {
    public let name: String //ツイートした人の名前
    public let screenName: String //ID　＠〜
    public let profileImageUrl: String  //プロフ画像URL
    public var profileBannerUrl: String? //バナー画像URL
    public let description: String //自己紹介
    public let createdAt: Date //Twitter始めた日
    public var location: String //場所
    public var link: [String]? //リンク
    public let friendsCount: Int //フォロー数
    public let followersCount: Int //フォロワー数
    public let following: Bool //フォロー状態
    public let verified: Bool //認証済み有無
}

public extension ProfileData {
    init?(profileData: JSON) {
        guard let name = profileData["name"].string else { return nil }
        guard let screenName = profileData["screen_name"].string else { return nil }
        guard let profileImageUrl = profileData["profile_image_url_https"].string else { return nil }
        if let profileBannerUrl = profileData["profile_banner_url"].string {
            self.profileBannerUrl = profileBannerUrl
        }
        guard let description = profileData["description"].string else { return nil }
        guard let createdAt = profileData["created_at"].string else { return nil }
        guard let createdAtFormatted = Date(fromISO8601: createdAt) else { return nil }
        guard  let location = profileData["location"].string else { return nil }
        if !profileData["entities"]["url"]["urls"].isEmpty {
            let urls = profileData["entities"]["url"]["urls"]
            let link = urls.compactMap { $0.1["display_url"].string }

            self.link = link
        }
        guard let friendsCount = profileData["friends_count"].int else { return nil }
        guard let followersCount = profileData["followers_count"].int else { return nil }
        guard let following = profileData["following"].bool else { return nil }
        guard let verified = profileData["verified"].bool else { return nil }
        
        self.name = name
        self.screenName = screenName
        self.profileImageUrl = profileImageUrl
        self.description = description
        self.createdAt = createdAtFormatted
        self.location = location
        self.friendsCount = friendsCount
        self.followersCount = followersCount
        self.following = following
        self.verified = verified
    }
}
