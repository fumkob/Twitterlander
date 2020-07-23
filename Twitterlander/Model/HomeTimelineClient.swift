//
//  HomeTimelineClient.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/13.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import OAuthSwift
import SwiftyJSON
import RxSwift

public class HomeTimelineClient {
    enum HomeTimelineClientError: Error {
        case getTimline
    }
    
    private var oauthswift: OAuthSwift?
    
    public func getHomeTimeline(url: String, token: [String:String]) -> Single<[HomeTimeline]> {
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
            oauthswift.client.get(url) {result in
                switch result {
                case .success(let response):
                    let jsonData = try? response.jsonObject()
                    guard let value = jsonData else {
                        fatalError("response in HomeTimeline could not be converted to JSON")
                    }
                    observer(.success(self.parseData(value: value)))
                case .failure:
                    observer(.error(HomeTimelineClientError.getTimline))
                }
            }
            
            return Disposables.create()
        }
    }
    private func parseData(value: Any) -> [HomeTimeline] {
        let homeData = JSON(value)
        //データを解析し、配列に格納する
        return homeData.map { HomeTimeline(homeData: $0.1) }
    }
}
