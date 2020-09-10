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
    
    public func getSearchResult(with client: OAuthClient, screenName: String) -> Single<[SearchResult]> {
        let urlString = searchUrlGenerator(screenName: screenName)
        guard let url = URL(string: urlString) else {
            fatalError("invalid url")
        }
        
        return client.getAPIRequestResult(of: url).map { $0["statuses"].map { SearchResult(searchData: $0.1) } }
    }
    
    public func searchUrlGenerator(screenName: String) -> String {
        let baseUrl = "https://api.twitter.com/1.1/search/tweets.json"
        let query = "q=to%3A" + screenName
        let count = "count=100"
        let resultType = "result_type=recent"
        let urlString = baseUrl + "?" + query + "&" + count + "&" + resultType
        return urlString
    }
}
