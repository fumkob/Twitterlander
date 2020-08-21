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

    public func getTimeline(with client: OAuthClient) -> Single<[Timeline]> {
        guard let url = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json") else {
            fatalError("invalid url")
        }
        
        return client.getAPIRequestResult(of: url).map { $0.map { Timeline(homeData: $0.1) } }
    }
}
