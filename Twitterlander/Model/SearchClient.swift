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
    public enum Error: Swift.Error {
        case decodeError
        case oauthClientError(APIError)
    }
    
    private var oauthswift: OAuthSwift?
    
    public func getSearchResult(with client: OAuthClient, screenName: String) -> Single<[SearchResult]> {
        let urlString = searchUrlGenerator(screenName: screenName)
        guard let url = URL(string: urlString) else {
            fatalError("invalid url")
        }
        
        return client.getAPIRequestResult(of: url)
            .catchError { error in
                guard let error = error as? APIError else { throw APIError.unknown }
                switch error {
                case .decodeError: throw Error.decodeError
                default: throw Error.oauthClientError(error)
                }
            }
            .map { jsons in
                let statusesInJsons = jsons["statuses"]
                switch statusesInJsons {
                case .null : throw Error.decodeError
                default:
                    return try statusesInJsons.map { (_, json) -> SearchResult in
                        guard let searchResult = SearchResult(searchData: json) else { throw Error.decodeError }
                        return searchResult
                    }
                }
            }
    }
        
    public func searchUrlGenerator(screenName: String) -> String {
        let baseUrl = "https://api.twitter.com/1.1/search/tweets.json"
        let count = String(100)
        let urlString = baseUrl + "?q=to%3A" + screenName + "&count=" + count + "&result_type=recent"
        return urlString
    }
}
