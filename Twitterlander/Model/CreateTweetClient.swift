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
    public func createTweet(with client: OAuthClient, tweet: String) -> Single<JSON> {
        guard let url = URL(string: createTweetUrlGenelator(tweet: tweet)) else {
            fatalError("Invalid URL")
        }
//        return client.postTweet(of: url)
//            .map{$0}
        return .create {observer in
            observer(.success(JSON("[]")))
            return Disposables.create()
        }
    }
    
    public func createTweetUrlGenelator(tweet: String) -> String {
        let url = "https://api.twitter.com/1.1/statuses/update.json?status=" + tweet
        guard let urlEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            fatalError("Cannot Encode")
        }
        return urlEncoded
    }
}
