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

class LoginViewController: ViewController<LoginViewModel>, LoginButtonDelegate, GIDSignInUIDelegate {
   
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        if viewModel.services.facebookAuth.checkAuthorization() {
            viewModel.services.user.userIds.facebookID = viewModel.services.facebookAuth.userID
            viewModel.services.database.getUserUUID(userID: viewModel.services.user.userIds.facebookID, type: .facebook, completion: {
                (_) in
                self.viewModel.move()
            }).bind(to: viewModel.services.user.userUuid).disposed(by: disposeBag)
            
        }
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
    
    func configureFacebookButton() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.loginBehavior = .web
        loginButton.center = view.center
        loginButton.center.y += 50
        view.addSubview(loginButton)
        loginButton.delegate = self
    }
    
    fileprivate func configureGoogleSignInButton() {
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.frame = CGRect(x: view.frame.width/2-100, y: view.frame.height/2-25, width: 200, height: 50)
        view.addSubview(googleSignInButton)
        //GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
}
