//
//  LoginViewController.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import FacebookLogin

class LoginViewController: ViewController<LoginViewModel>, LoginButtonDelegate {
    
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
        
        
    }
    
    func configureFacebookButton() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.loginBehavior = .web
        loginButton.center = view.center
        loginButton.center.y += 50
        view.addSubview(loginButton)
        loginButton.delegate = self
    }
    
    
}
