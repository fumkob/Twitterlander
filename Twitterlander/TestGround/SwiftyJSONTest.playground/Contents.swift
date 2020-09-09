import UIKit
import SwiftyJSON

class SearchResult {
    var test: String
    init?(searchData: JSON) {
        guard let test = searchData["test"].string else {return nil}
        self.test = test
    }
}

enum Error: Swift.Error {
    case decodeError
}

let json = JSON("{\"hoge\":1}")
let parseJson = json["statuses"]
if parseJson == .null {
    print("ぬるぽ")
} else {
    let mappedJson = parseJson.map { (_, json) -> SearchResult in
        guard let searchResult = SearchResult(searchData: json) else { throw Error.decodeError }
        print(searchResult)
        return searchResult
    }
}

