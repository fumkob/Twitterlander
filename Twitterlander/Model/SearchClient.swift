//
//  SearchClient.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/27.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import OAuthSwift
import SwiftyJSON
import RxSwift

public class SearchClient {
    private var oauthswift: OAuthSwift?
    public func getSearchResult(url: String, token: [String:String]) -> Single<[SearchResult]> {
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
                    let wrappedData = try? response.jsonObject()
                    guard let unwrappedData = wrappedData else {
                        fatalError("wrappedData is nil")
                    }
                    let jsonData = JSON(unwrappedData)
                    observer(.success(jsonData["statuses"].map { SearchResult(searchData: $0.1) }))
                case .failure:
                    observer(.error(APIError.getSearchResultError))
                }
            }
            
            return Disposables.create()
        }
    }
}
