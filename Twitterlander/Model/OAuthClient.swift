//
//  OAuthClient.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/10.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import OAuthSwift

open class OAuthClient {
    enum OAuthClientError: Error {
        case getOAuth
    }
    private var oauthswift: OAuthSwift?
    private var token: [String : String] = [
        "oauthToken" : "",
        "oauthTokenSecret" : ""
    ]
    
    open func getOAuthToken() -> Single<[String : String]> {
        return .create {observer in
            let oauthswift = OAuth1Swift(
                consumerKey:    "aiSbp28ZF965SD1bQwDP4YHG2",
                consumerSecret: "ifXPVrate6VNPgUtIhimd5qOEmF0gd2hJYfobSFlFQ7GHCNAUn",
                requestTokenUrl: "https://api.twitter.com/oauth/request_token",
                authorizeUrl:    "https://api.twitter.com/oauth/authorize",
                accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
            )
            self.oauthswift = oauthswift
            _ = oauthswift.authorize(
            withCallbackURL: URL(string: "twitterlander://")!) { result in
                switch result {
                case .success(let (credential, _, _)):
                    self.token["oauthToken"] = credential.oauthToken
                    self.token["oauthTokenSecret"] = credential.oauthTokenSecret
                    observer(.success(self.token))
                case .failure:
                    observer(.error(OAuthClientError.getOAuth))
                }
            }
            return Disposables.create()
        }
    }
}
