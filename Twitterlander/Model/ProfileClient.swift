//
//  ProfileClient.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/31.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import OAuthSwift
import SwiftyJSON
import RxSwift

public class ProfileClient {
    private var oauthswift: OAuthSwift?
    
    public func getProfile(with client: OAuthClient, screenName: String) -> Single<ProfileData> {
        let urlString = profileUrlGenerator(screenName: screenName)
        guard let url = URL(string: urlString) else {
            fatalError("invalid url")
        }
        
        return client.getAPIRequestResult(of: url).map { ProfileData(profileData: $0) }
    }
    
    public func profileUrlGenerator(screenName: String) -> String {
        let baseUrl = "https://api.twitter.com/1.1/users/show.json"
        let name = "screen_name=" + screenName
        let urlString = baseUrl + "?" + name
        return urlString
    }
}
