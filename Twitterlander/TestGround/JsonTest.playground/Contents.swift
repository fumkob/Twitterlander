/*
import UIKit
import SwiftyJSON

class JsonTest {
    var path: String?
    
    func setting() -> Data? {
        guard let path = Bundle.main.path(forResource: "sample", ofType: "json") else {return nil}
        self.path = path
        let url = URL(fileURLWithPath: path)
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}

let test = JsonTest()
let json = test.setting()
//print(json!)
let jsonData = JSON(json!)
//print(jsonData[0]["created_at"])
//print("tes2t")


extension Date {
    private struct Const {
        static let ISO8601Formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            return dateFormatter
        }()
        
        static let japaneseStyle: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
            return formatter
        }()
    }
    init?(fromISO8601 string: String) {
        guard let date = Const.ISO8601Formatter.date(from: string) else {
            return nil
        }
        self = date
    }
    
    func japaneseStyleDate() -> String {
        return Const.japaneseStyle.string(from: self)
    }
}
let time = jsonData[0]["created_at"].string
let timeFormatted = Date(fromISO8601: time!)
//print(timeFormatted)


struct HomeTimeline {
    enum MediaType {
        case photo
        case movie
    }
    
    public let name: String //ツイートした人の名前
    public let screenName: String //ID　＠〜
    public let profileImageUrl: String  //プロフ画像URL
    public let text: String //ツイート文
    public let createdAt: Date //ツイート日時
    public let mediaUrl: [String]? //投稿した写真URL
    public let mediaType: [MediaType]? //写真か動画か選択
    public let retweetedStatus: Bool //リツイートかの判定
    public let retweetedName: String? //リツイートされた人の名前
    public let retweetedScreenName: String? //リツイートされた人のID
    public let retweetedProfileImageUrl: String? //リツイートされた人のプロフ画像URL
    public let retweetedText: String? //リツイートされた本文
    public let retweetedCreatedAt: Date? //リツイートされたツイート日時
    public let retweetedMediaUrl: [String]? //投稿した写真URL
    public let retweetedMediaType: [MediaType]? //写真か動画か選択
    public let quotedStatus: Bool //引用リツイートかの判定
    public let quotedName: String? //引用された人の名前
    public let quotedScreenName: String? //引用された人のID
    public let quotedProfileImageUrl: String? //引用された人のプロフ画像URL
    public let quotedText: String? //引用リツイート文
    public let quotedCreatedAt: Date? //引用リツイート日時
    public let quotedMediaUrl: [String]? //投稿した写真URL
    public let quotedMediaType: [MediaType]? //写真か動画か選択
    public let retweetCount: Int //リツイート数
    public let favoriteCount: Int //ファボ数
    public let isRetweeted: Bool //リツイートしたか？
    public let isFavorited: Bool //ファボしたか？
    public let verified: Bool //認証済み有無
    public let source: String //ツイートしたアプリ名
    public let isReply: Bool //リプライ判断（リプライの場合の実装は別途検討）

    
    init(homeData: JSON) {
        //ツイート情報
        guard let name = homeData["user"]["name"].string else {
            fatalError("name is missing")
        }
        guard let screenName = homeData["user"]["screen_name"].string else {
            fatalError("screen_name is missing")
        }
        guard let profileImageUrl = homeData["user"]["profile_image_url_https"].string else {
            fatalError("profile_image_url_httpsis missing")
        }
        guard let text = homeData["text"].string else {
            fatalError("text missing")
        }
        guard let createdAt = homeData["created_at"].string else {
            fatalError("created_at missing")
        }
        guard let createdAtFormatted = Date(fromISO8601: createdAt) else {
            fatalError("createdAt can not be formatted")
        }
        self.name = name
        self.screenName = screenName
        self.profileImageUrl = profileImageUrl
        self.text = text
        self.createdAt = createdAtFormatted
        
        if !homeData["entities"]["media"].isEmpty {
            let media = homeData["entities"]["media"]
            let mediaUrl = media.compactMap { $0.1["media_url_https"].string }
            let mediaType:[MediaType] = media.compactMap {
                switch $0.1["type"].string {
                case "photo":
                    return .photo
                case "movie":
                    return .movie
                default:
                    return nil
                }
            }
            self.mediaUrl = mediaUrl
            self.mediaType = mediaType
        } else {
            self.mediaUrl = nil
            self.mediaType = nil
        }
        
        //リツイート情報
        if homeData["retweeted_status"].isEmpty {
            self.retweetedStatus = false
        } else {
            self.retweetedStatus = true
        }
        if let retweetedName = homeData["retweeted_status"]["user"]["name"].string {
            self.retweetedName = retweetedName
        } else {
            self.retweetedName = nil
        }
        if let retweetedScreenName = homeData["retweeted_status"]["user"]["screen_name"].string {
            self.retweetedScreenName = retweetedScreenName
        } else {
            self.retweetedScreenName = nil
        }
        if let retweetedProfileImageUrl = homeData["retweeted_status"]["user"]["profile_image_url_https"].string {
            self.retweetedProfileImageUrl = retweetedProfileImageUrl
        } else {
            self.retweetedProfileImageUrl = nil
        }
        if let retweetedText = homeData["retweeted_status"]["text"].string {
            self.retweetedText = retweetedText
        } else {
            self.retweetedText = nil
        }
        if let retweetedCreatedAt = homeData["retweeted_status"]["created_at"].string {
            let retweetedCreatedAtFormatted = Date(fromISO8601: retweetedCreatedAt)
            self.retweetedCreatedAt = retweetedCreatedAtFormatted
        } else {
            self.retweetedCreatedAt = nil
        }
        if !homeData["retweeted_status"]["entities"]["media"].isEmpty {
            let retweetedMedia = homeData["retweeted_status"]["entities"]["media"]
            let retweetedMediaUrl = retweetedMedia.compactMap { $0.1["media_url_https"].string }
            let retweetedMediaType:[MediaType] = retweetedMedia.compactMap {
                switch $0.1["type"].string {
                case "photo":
                    return .photo
                case "movie":
                    return .movie
                default:
                    return nil
                }
            }
            self.retweetedMediaUrl = retweetedMediaUrl
            self.retweetedMediaType = retweetedMediaType
        } else {
            self.retweetedMediaUrl = nil
            self.retweetedMediaType = nil
        }
        
        //引用ツイート情報
        if homeData["quoted_status"].isEmpty {
            self.quotedStatus = false
        } else {
            self.quotedStatus = true
        }
        if let quotedName = homeData["quoted_status"]["user"]["name"].string {
            self.quotedName = quotedName
        } else {
            self.quotedName = nil
        }
        if let quotedScreenName = homeData["quoted_status"]["user"]["screen_name"].string {
            self.quotedScreenName = quotedScreenName
        } else {
            self.quotedScreenName = nil
        }
        if let quotedProfileImageUrl = homeData["quoted_status"]["user"]["profile_image_url_https"].string {
            self.quotedProfileImageUrl = quotedProfileImageUrl
        } else {
            self.quotedProfileImageUrl = nil
        }
        if let quotedText = homeData["quoted_status"]["text"].string {
            self.quotedText = quotedText
        } else {
            self.quotedText = nil
        }
        if let quotedCreatedAt = homeData["quoted_status"]["created_at"].string {
            let quotedCreatedAtFormatted = Date(fromISO8601: quotedCreatedAt)
            self.quotedCreatedAt = quotedCreatedAtFormatted
        } else {
            self.quotedCreatedAt = nil
        }
        if !homeData["quoted_status"]["entities"]["media"].isEmpty {
            let quotedMedia = homeData["quoted_status"]["entities"]["media"]
            let quotedMediaUrl = quotedMedia.compactMap { $0.1["media_url_https"].string }
            let quotedMediaType:[MediaType] = quotedMedia.compactMap {
                switch $0.1["type"].string {
                case "photo":
                    return .photo
                case "movie":
                    return .movie
                default:
                    return nil
                }
            }
            self.quotedMediaUrl = quotedMediaUrl
            self.quotedMediaType = quotedMediaType
        } else {
            self.quotedMediaUrl = nil
            self.quotedMediaType = nil
        }
        
        //一般情報
        guard let retweetCount = homeData["retweet_count"].int else {
            fatalError("retweet_count is missing")
        }
        guard let favoriteCount = homeData["favorite_count"].int else {
            fatalError("favorite_count is missing")
        }
        guard let isRetweeted = homeData["retweeted"].bool else {
            fatalError("retweeted is missing")
        }
        guard let isFavorited = homeData["favorited"].bool else {
            fatalError("favorited is missing")
        }
        guard let verified = homeData["user"]["verified"].bool else {
            fatalError("verified is missing")
        }
        guard let source = homeData["source"].string else {
            fatalError("source is missing")
        }
        self.retweetCount = retweetCount
        self.favoriteCount = favoriteCount
        self.isRetweeted = isRetweeted
        self.isFavorited = isFavorited
        self.verified = verified
        self.source = source
        
        if let _ = homeData["in_reply_to_status_id_str"].string {
            self.isReply = true
        } else{
            self.isReply = false
        }
    }
}

let homeTimeline = jsonData.map {HomeTimeline(homeData: $0.1)}
print(homeTimeline[0])
print("\n")
print(homeTimeline[1])
print("\n")
print(homeTimeline[2])
print("\n")
print(homeTimeline[3])
print("\n")
print(homeTimeline[4])
print("\n")
print(homeTimeline[5])
*/
