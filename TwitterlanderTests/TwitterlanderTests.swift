//
//  TwitterlanderTests.swift
//  TwitterlanderTests
//
//  Created by Fumiaki Kobayashi on 2020/07/09.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
import RxSwift
@testable import Twitterlander

class TwitterlanderTests: XCTestCase {
    
    private var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    let userDefaults = UserDefaults.standard
    func testCheckAccessTokenExists() {
        let oAuthClient: OAuthClient = LoginClientMockFactory.emptyOAuthClient()
        let loginViewModel = LoginViewModel(client: oAuthClient)
        let transitionToHome = loginViewModel.transitionToHome
        
        loginViewModel.checkOAuthTokenExsits()
        transitionToHome
            .drive(onNext: {
                let tokenExists = (self.userDefaults.dictionary(forKey: "token") as? [String : String]) != nil
                switch $0 {
                case true:
                    XCTAssertTrue(tokenExists, "Token does not exists even though transitionToHome is true")
                case false:
                    XCTAssertFalse(tokenExists, "Token exists even though transitionToHome is false")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func testLoginProcessing() {
        let oAuthClient: OAuthClient = LoginClientMockFactory.emptyOAuthClient()
        let loginViewModel = LoginViewModel(client: oAuthClient)
        let transitionToHome = loginViewModel.transitionToHome
        
        loginViewModel.loginProcessing()
        transitionToHome
        .drive(onNext: {
            let tokenExists = (self.userDefaults.dictionary(forKey: "token") as? [String : String]) != nil
            switch $0 {
            case true:
                XCTAssertTrue(tokenExists, "Token does not exists even though transitionToHome is true")
            case false:
                XCTAssertFalse(tokenExists, "Token exists even though transitionToHome is false")
            }
        })
        .disposed(by: disposeBag)
    }
}

class LoginClientMockFactory {
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
