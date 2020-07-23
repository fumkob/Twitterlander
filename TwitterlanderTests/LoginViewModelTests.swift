//
//  LoginViewModelTests.swift
//  LoginViewModelTests
//
//  Created by Fumiaki Kobayashi on 2020/07/09.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
@testable import Twitterlander

class LoginViewModelTests: XCTestCase {
    
    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    let userDefaults = UserDefaults.standard
    func testCheckAccessTokenExists() {
        let oauthClient: OAuthClient = OAuthClientMockFactory.emptyOAuthClient()
        let loginViewModel = LoginViewModel(client: oauthClient)
        let transitionToHome = loginViewModel.transitionToHome
        
        loginViewModel.checkOAuthTokenExsits()
        transitionToHome
            .drive(onNext: {
                if let token:[String:String] = self.userDefaults.dictionary(forKey: "token") as? [String : String] {
                    if !token.isEmpty {
                        XCTAssertTrue($0, "Token exists even though transitionToHome is false")
                    } else {
                        XCTAssertFalse($0, "Token does not exists even though transitionToHome is true")
                    }
                } else {
                    XCTAssertFalse($0, "Token does not exists even though transitionToHome is true")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func testLoginProcessing() {
        let oAuthClient: OAuthClient = OAuthClientMockFactory.emptyOAuthClient()
        let loginViewModel = LoginViewModel(client: oAuthClient)
        let transitionToHome = loginViewModel.transitionToHome
        
        loginViewModel.loginProcessing()
        transitionToHome
        .drive(onNext: {
            if self.userDefaults.dictionary(forKey: "token") as? [String : String] != nil {
                XCTAssertTrue($0, "Token exists even though transitionToHome is false")
            } else {
                XCTAssertFalse($0, "Token does not exists even though transitionToHome is true")
            }
        })
        .disposed(by: disposeBag)
    }
}

class OAuthClientMockFactory {
    class OAuthClientMock: OAuthClient {
        override func getOAuthToken() -> Single<[String : String]> {
            return .create(subscribe : {observer in
                observer(.success([:]))
                return Disposables.create()
            })
        }
        
    }
    static func emptyOAuthClient() -> OAuthClient {
        return OAuthClientMock()
    }
}
