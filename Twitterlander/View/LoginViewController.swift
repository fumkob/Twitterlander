//
//  LoginViewController.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/10.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    private var disposeBag = DisposeBag()
    private var loginViewModel: LoginViewModel!
    @IBOutlet weak var loginButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewSetup()
        loginButtonTapped()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginToHome()
    }
    
    private func loginViewSetup() {
        self.loginViewModel = LoginViewModel(client: OAuthClient())
        //OAuthTokenが保存されているか確認する
        loginViewModel.checkOAuthTokenExsits()
    }
    //ログインボタンが押された時の処理
    private func loginButtonTapped() {
        loginButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.loginViewModel.loginProcessing()
            })
            .disposed(by: disposeBag)
    }
    //ログイン画面からHome画面へ遷移する
    private func loginToHome() {
        loginViewModel.transitionToHome
            .drive(onNext: {[weak self] in
                if $0 {
                    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    guard let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "home") as? HomeViewController else {
                        fatalError("Storyboard named \"Home\" does NOT exists.")
                    }
                    self?.present(homeViewController, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}
