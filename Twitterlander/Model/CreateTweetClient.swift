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
    
    public enum Error: Swift.Error {
        case oauthClientError(APIError)
    }
    
    public func createTweet(with client: OAuthClient, tweet: String) -> Single<JSON> {
        guard let url = URL(string: createTweetUrlGenelator(tweet: tweet)) else {
            fatalError("Invalid URL")
        }
        return client.postTweet(of: url)
            .catchError { error in
                guard let error = error as? APIError else { throw APIError.unknown }
                throw Error.oauthClientError(error)
            }
            .map { $0 }
      }
    
    public func createTweetUrlGenelator(tweet: String) -> String {
        let url = "https://api.twitter.com/1.1/statuses/update.json?status=" + tweet
        guard let urlEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            fatalError("Cannot Encode")
        }
        return urlEncoded
    }
}
