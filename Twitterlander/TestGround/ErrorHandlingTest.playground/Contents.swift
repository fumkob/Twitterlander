import UIKit
import RxSwift

enum APIError: Error {
    case authError
    case decodeError
}

class TestClient {
    enum Error: Swift.Error {
        case decodeError
        case apiError(APIError)
    }
    
    func getAPI(flag: Bool) -> Single<String> {
        return .create{ observer in
            switch flag {
            case true: observer(.success("Sucess!!"))
            case false: observer(.error(APIError.authError))
            }
            return Disposables.create()
        }
    }
}

//let testClient = TestClient()
//testClient.getAPI(flag: false)
//    .subscribe { (message) in
//        print(message)
//    } onError: { error in
//        let error = error as! Error
//        print(error)
//        print(type(of: error))
//    }
//
//testClient.getAPI(flag: false)
//    .catchError { error in
//        let error = error as! APIError
//        switch error {
//        case .decodeError: throw TestClient.Error.decodeError
//        default :
//            throw TestClient.Error.apiError(error)
//        }
//    }
