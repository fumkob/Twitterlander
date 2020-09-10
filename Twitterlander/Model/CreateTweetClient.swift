//
//  CreateTweetClient.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/08/04.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import OAuthSwift
import SwiftyJSON
import RxSwift

public class CreateTweetClient {
    private var oauthswift: OAuthSwift?    
    public func postTweet(url: String, token: [String:String]) -> Single<JSON> {
        return .create {observer in
            let oauthswift = OAuth1Swift(
                consumerKey:    "aiSbp28ZF965SD1bQwDP4YHG2",
                consumerSecret: "ifXPVrate6VNPgUtIhimd5qOEmF0gd2hJYfobSFlFQ7GHCNAUn"
            )
            guard let oauthToken = token["oauthToken"] else {
                fatalError("oauthToken is nil")
            }
            guard let oauthTokenSecret = token["oauthTokenSecret"] else {
                fatalError("oauthTokenSecret is nil")
            }
            oauthswift.client.credential.oauthToken = oauthToken
            oauthswift.client.credential.oauthTokenSecret = oauthTokenSecret
            oauthswift.client.post(url) {result in
                switch result {
                case .success(let response):
                    let jsonData = try? response.jsonObject()
                    guard let unwrappedJsonData = jsonData else {
                        fatalError("response in HomeTimeline could not be converted to JSON")
                    }
                    observer(.success(JSON(unwrappedJsonData)))
                case .failure:
                    observer(.error(APIError.postCreateTweetError))
                }
            }
            
            return Disposables.create()
        }
    }

}
