//
//  TimelineClientTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/08/18.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
import SwiftyJSON
@testable import Twitterlander

class TimelineClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let oauthClientMock = OAuthClientMockFactory2.emptyOAuthClient()
        let timelineClient = TimelineClient()
        
        let exp = self.expectation(description: "Do not call")
        
        timelineClient.getTimeline(with: oauthClientMock)
            .subscribe(onSuccess: { response in
                XCTAssertEqual(response[0].screenName, "Kanonnyanko")
                exp.fulfill()
            })
        switch XCTWaiter.wait(for: [exp], timeout: 2.0) {
        case .completed: break
        case .timedOut: XCTFail("timeout")
        default: XCTFail("uncompleted")
        }
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class OAuthClientMockFactory2 {
    class OAuthClientMock: OAuthClient {
        override func getAPIRequestResult(of url: URL) -> Single<JSON> {
            return .create(subscribe : {observer in
//                guard let data = jsonString.data(using: .utf8) else { return Disposables.create() }
//                guard let json = try? JSON.init(data: data, options: .fragmentsAllowed) else { return Disposables.create() }
                // swiftlint:disable force_try
                let url = URL(fileURLWithPath: "/Users/fumiaki/Documents/Training/Twitterlander/Twitterlander/Twitterlander/TestGround/JsonTest.playground/Resources/sample.json")
                observer(.success(try! JSON.init(data: try! Data(contentsOf: url))))
                return Disposables.create()
            })
        }
        
    }
    static func emptyOAuthClient() -> OAuthClient {
        return OAuthClientMock()
    }
}
let jsonString2 = """
[
    {"age" : 12},
    {"age" : 13}
]
"""
let jsonString = """

"""
let jsonString3 = """
[
    {
        "created_at": "Tue Aug 18 01:45:45 +0000 2020",
        "id": 1295537334897655800,
        "id_str": "1295537334897655810",
        "text": "※現在は、新型コロナウィルス感染拡大防止のためクリスタルに手を触れず、かざすようお願いしております",
        "truncated": false,
        "entities": {
            "hashtags": [],
            "symbols": [],
            "user_mentions": [],
            "urls": []
        },
        "source": "<a href=\"https://mobile.twitter.com\" rel=\"nofollow\">Twitter Web App</a>",
        "in_reply_to_status_id": 1295537081339408400,
        "in_reply_to_status_id_str": "1295537081339408384",
        "in_reply_to_user_id": 82827599,
        "in_reply_to_user_id_str": "82827599",
        "in_reply_to_screen_name": "NissanJP",
        "user": {
            "id": 82827599,
            "id_str": "82827599",
            "name": "日産自動車株式会社",
            "screen_name": "NissanJP",
            "location": "Yokohama",
            "description": "日産自動車公式アカウント。企業や商品に関する情報について発信してまいります。なお現在お乗りのお車や販売店等でお困りのことは https://t.co/yOIfqfscFr にお願いいたします。",
            "url": "https://t.co/Y44nOHkkZx",
            "entities": {
                "url": {
                    "urls": [
                        {
                            "url": "https://t.co/Y44nOHkkZx",
                            "expanded_url": "http://www.nissan.co.jp/",
                            "display_url": "nissan.co.jp",
                            "indices": [
                                0,
                                23
                            ]
                        }
                    ]
                },
                "description": {
                    "urls": [
                        {
                            "url": "https://t.co/yOIfqfscFr",
                            "expanded_url": "https://bit.ly/2H1OLlO",
                            "display_url": "bit.ly/2H1OLlO",
                            "indices": [
                                62,
                                85
                            ]
                        }
                    ]
                }
            },
            "protected": false,
            "followers_count": 275205,
            "friends_count": 15049,
            "listed_count": 3124,
            "created_at": "Fri Oct 16 07:56:17 +0000 2009",
            "favourites_count": 2428,
            "utc_offset": null,
            "time_zone": null,
            "geo_enabled": true,
            "verified": true,
            "statuses_count": 28863,
            "lang": null,
            "contributors_enabled": false,
            "is_translator": false,
            "is_translation_enabled": false,
            "profile_background_color": "131516",
            "profile_background_image_url": "http://abs.twimg.com/images/themes/theme1/bg.png",
            "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme1/bg.png",
            "profile_background_tile": false,
            "profile_image_url": "http://pbs.twimg.com/profile_images/1283276562331168768/KUanlgF3_normal.jpg",
            "profile_image_url_https": "https://pbs.twimg.com/profile_images/1283276562331168768/KUanlgF3_normal.jpg",
            "profile_banner_url": "https://pbs.twimg.com/profile_banners/82827599/1594792460",
            "profile_link_color": "99002B",
            "profile_sidebar_border_color": "FFFFFF",
            "profile_sidebar_fill_color": "FFFFFF",
            "profile_text_color": "333333",
            "profile_use_background_image": true,
            "has_extended_profile": false,
            "default_profile": false,
            "default_profile_image": false,
            "following": true,
            "follow_request_sent": false,
            "notifications": false,
            "translator_type": "none"
        },
        "geo": null,
        "coordinates": null,
        "place": null,
        "contributors": null,
        "is_quote_status": false,
        "retweet_count": 6,
        "favorite_count": 67,
        "favorited": false,
        "retweeted": false,
        "lang": "ja"
    },
    {
        "created_at": "Tue Aug 18 01:44:44 +0000 2020",
        "id": 1295537081339408400,
        "id_str": "1295537081339408384",
        "text": "【 #おのけんナビ CITY②】\n活性化する街を体験。クルマと人・街が、電力や情報をシェアし合う世の中をイメージした光の演出の空間です。\nhttps://t.co/09viTDDL0h\n\n#ニッサンパビリオン… https://t.co/uE7xC8HsxW",
        "truncated": true,
        "entities": {
            "hashtags": [
                {
                    "text": "おのけんナビ",
                    "indices": [
                        2,
                        9
                    ]
                },
                {
                    "text": "ニッサンパビリオン",
                    "indices": [
                        94,
                        104
                    ]
                }
            ],
            "symbols": [],
            "user_mentions": [],
            "urls": [
                {
                    "url": "https://t.co/09viTDDL0h",
                    "expanded_url": "https://www.nissan.co.jp/BRAND/PAVILION/?scsocid=t00000501",
                    "display_url": "nissan.co.jp/BRAND/PAVILION…",
                    "indices": [
                        69,
                        92
                    ]
                },
                {
                    "url": "https://t.co/uE7xC8HsxW",
                    "expanded_url": "https://twitter.com/i/web/status/1295537081339408384",
                    "display_url": "twitter.com/i/web/status/1…",
                    "indices": [
                        106,
                        129
                    ]
                }
            ]
        },
        "source": "<a href=\"https://studio.twitter.com\" rel=\"nofollow\">Twitter Media Studio</a>",
        "in_reply_to_status_id": null,
        "in_reply_to_status_id_str": null,
        "in_reply_to_user_id": null,
        "in_reply_to_user_id_str": null,
        "in_reply_to_screen_name": null,
        "user": {
            "id": 82827599,
            "id_str": "82827599",
            "name": "日産自動車株式会社",
            "screen_name": "NissanJP",
            "location": "Yokohama",
            "description": "日産自動車公式アカウント。企業や商品に関する情報について発信してまいります。なお現在お乗りのお車や販売店等でお困りのことは https://t.co/yOIfqfscFr にお願いいたします。",
            "url": "https://t.co/Y44nOHkkZx",
            "entities": {
                "url": {
                    "urls": [
                        {
                            "url": "https://t.co/Y44nOHkkZx",
                            "expanded_url": "http://www.nissan.co.jp/",
                            "display_url": "nissan.co.jp",
                            "indices": [
                                0,
                                23
                            ]
                        }
                    ]
                },
                "description": {
                    "urls": [
                        {
                            "url": "https://t.co/yOIfqfscFr",
                            "expanded_url": "https://bit.ly/2H1OLlO",
                            "display_url": "bit.ly/2H1OLlO",
                            "indices": [
                                62,
                                85
                            ]
                        }
                    ]
                }
            },
            "protected": false,
            "followers_count": 275205,
            "friends_count": 15049,
            "listed_count": 3124,
            "created_at": "Fri Oct 16 07:56:17 +0000 2009",
            "favourites_count": 2428,
            "utc_offset": null,
            "time_zone": null,
            "geo_enabled": true,
            "verified": true,
            "statuses_count": 28863,
            "lang": null,
            "contributors_enabled": false,
            "is_translator": false,
            "is_translation_enabled": false,
            "profile_background_color": "131516",
            "profile_background_image_url": "http://abs.twimg.com/images/themes/theme1/bg.png",
            "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme1/bg.png",
            "profile_background_tile": false,
            "profile_image_url": "http://pbs.twimg.com/profile_images/1283276562331168768/KUanlgF3_normal.jpg",
            "profile_image_url_https": "https://pbs.twimg.com/profile_images/1283276562331168768/KUanlgF3_normal.jpg",
            "profile_banner_url": "https://pbs.twimg.com/profile_banners/82827599/1594792460",
            "profile_link_color": "99002B",
            "profile_sidebar_border_color": "FFFFFF",
            "profile_sidebar_fill_color": "FFFFFF",
            "profile_text_color": "333333",
            "profile_use_background_image": true,
            "has_extended_profile": false,
            "default_profile": false,
            "default_profile_image": false,
            "following": true,
            "follow_request_sent": false,
            "notifications": false,
            "translator_type": "none"
        },
        "geo": null,
        "coordinates": null,
        "place": null,
        "contributors": null,
        "is_quote_status": false,
        "retweet_count": 197,
        "favorite_count": 1666,
        "favorited": false,
        "retweeted": false,
        "possibly_sensitive": false,
        "possibly_sensitive_appealable": false,
        "lang": "ja"
    }
]
"""
