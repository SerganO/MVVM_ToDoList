//
//  LoginViewController.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import FacebookLogin
import GoogleSignIn

class LoginViewController: ViewController<LoginViewModel>, LoginButtonDelegate, GIDSignInUIDelegate /*, GIDSignInDelegate*/ {
    
    /*func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            viewModel.services.user.userIds.googleID = user.userID
            viewModel.services.database.getUserUUID(userID: self.viewModel.services.user.userIds.googleID, type: .google, completion: {
                (_) in
                self.viewModel.move()
            }).bind(to: self.viewModel.services.user.userUuid).disposed(by: self.disposeBag)
        }
    }*/
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        viewModel.services.facebookAuth.checkAuthorization({
            result in
            if result {
                self.viewModel.services.user.userIds.facebookID = self.viewModel.services.facebookAuth.userID
                self.viewModel.services.database.getUserUUID(userID: self.viewModel.services.user.userIds.facebookID, type: .facebook, completion: {
                    (_) in
                    self.viewModel.move()
                }).bind(to: self.viewModel.services.user.userUuid).disposed(by: self.disposeBag)
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        viewModel.services.facebookAuth.userID = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        
        
        configureFacebookButton()
        configureGoogleSignInButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.services.user.navigationCompletion = {
            (result) in
            self.viewModel.move()
        }
        
    }
    
    func configureFacebookButton() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.loginBehavior = .web
        loginButton.center = view.center
        loginButton.center.y += 50
        view.addSubview(loginButton)
        loginButton.delegate = self
    }
    
    func configureGoogleSignInButton() {
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.frame = CGRect(x: view.frame.width/2-100, y: view.frame.height/2-25, width: 200, height: 50)
        view.addSubview(googleSignInButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        /*GIDSignIn.sharedInstance().delegate = self*/
    }
    
    
}
