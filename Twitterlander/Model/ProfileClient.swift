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
    
    public enum Error: Swift.Error {
        case decodeError
        case oauthClientError(APIError)
    }
        
    public func getProfile(with client: OAuthClient, screenName: String) -> Single<ProfileData> {
        let urlString = profileUrlGenerator(screenName: screenName)
        guard let url = URL(string: urlString) else {
            fatalError("invalid url")
        }
        
        return client.getAPIRequestResult(of: url)
            .catchError { error in
                guard let error = error as? APIError else { throw APIError.unknown }
                throw Error.oauthClientError(error)
        }
            .map { json in
                guard let profileData = ProfileData(profileData: json) else { throw Error.decodeError }
                return profileData
        }
    }
    
    public func profileUrlGenerator(screenName: String) -> String {
        let baseUrl = "https://api.twitter.com/1.1/users/show.json"
        let name = "screen_name=" + screenName
        let urlString = baseUrl + "?" + name
        return urlString
    }
}
