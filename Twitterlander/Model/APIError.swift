//
//  APIError.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/24.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case postCreateTweetError
    case wrongSetting
    case decodeError
    case serverError
    case unauthorized
    case requestError(Error, URLRequest?)
    case unknown
}
