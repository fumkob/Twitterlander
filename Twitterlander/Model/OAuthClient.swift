//
//  OAuthClient.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/10.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import RxSwift
import OAuthSwift
import SwiftyJSON

open class OAuthClient {
    private let oauthswift: OAuth1Swift = OAuth1Swift(
        consumerKey:    "aiSbp28ZF965SD1bQwDP4YHG2",
        consumerSecret: "ifXPVrate6VNPgUtIhimd5qOEmF0gd2hJYfobSFlFQ7GHCNAUn",
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl:    "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
    )
    private var token: [String:String] = [
        "oauthToken" : "",
        "oauthTokenSecret" : ""
    ]
    private let userDefaults = UserDefaults.standard
    
    open func getOAuthToken() -> Single<[String:String]> {
        return .create {observer in
            self.oauthswift.authorize(
            withCallbackURL: URL(string: "twitterlander://")!) { result in
                switch result {
                case .success(let (credential, _, _)):
                    self.token["oauthToken"] = credential.oauthToken
                    self.token["oauthTokenSecret"] = credential.oauthTokenSecret
                    observer(.success(self.token))
                case .failure:
                    observer(.error(APIError.wrongSetting))
                }
            }
            return Disposables.create()
        }
    }
    
    open func getAPIRequestResult(of url: URL) -> Single<JSON> {
        return .create {observer in
            self.tokenSetup()
            self.oauthswift.client.get(url) {result in
                switch result {
                case .success(let response):
                    let jsonData = try? response.jsonObject()
                    guard let data = jsonData else {
                        fatalError("response could not be converted to JSON")
                    }
                    observer(.success(JSON(data)))
                case .failure(.serverError): observer(.error(APIError.serverError))
                case .failure(.accessDenied): observer(.error(APIError.unauthorized))
                case .failure(.tokenExpired): observer(.error(APIError.unauthorized))
                case .failure(.configurationError): observer(.error(APIError.wrongSetting))
                case let .failure(.requestError(error, request)): observer(.error(APIError.requestError(error, request)))
                case .failure:
                    observer(.error(APIError.unknown))
                }
            }
            
            return Disposables.create()
        }
    }
    open func postTweet(of url: URL) -> Single<JSON> {
        return .create {observer in
            self.tokenSetup()
            self.oauthswift.client.post(url) {result in
                switch result {
                case .success(let response):
                    let jsonData = try? response.jsonObject()
                    guard let data = jsonData else {
                        fatalError("response could not be converted to JSON")
                    }
                    observer(.success(JSON(data)))
                case .failure:
                    observer(.error(APIError.postCreateTweetError))
                }
            }

            return Disposables.create()
        }
    }
    
    private func tokenSetup() {
        guard let token = self.userDefaults.dictionary(forKey: "token") as? [String:String] else {
            fatalError("Invalid token")
        }
        guard let oauthToken = token["oauthToken"] else {
            fatalError("oauthToken is nil")
        }
        guard let oauthTokenSecret = token["oauthTokenSecret"] else {
            fatalError("oauthTokenSecret is nil")
        }
        self.oauthswift.client.credential.oauthToken = oauthToken
        self.oauthswift.client.credential.oauthTokenSecret = oauthTokenSecret
    }
}
