//
//  TimelineClient.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/13.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import OAuthSwift
import SwiftyJSON
import RxSwift

public class TimelineClient {
    
    public enum Error: Swift.Error {
        case decodeError
        case oauthClientError(APIError)
    }
    
    public func getTimeline(with client: OAuthClient, url: URL) -> Single<[Timeline]> {
  
        return client.getAPIRequestResult(of: url)
            .catchError { error in
                guard let error = error as? APIError else { throw APIError.unknown }
                switch error {
                case .decodeError: throw  Error.decodeError
                default: throw Error.oauthClientError(error)
                }
            }
            .map { jsons in
                return try jsons.map { (_, json) -> Timeline in
                    guard let timeline = Timeline(homeData: json) else { throw Error.decodeError }
                    return timeline
                }
        }
    }
    
}
