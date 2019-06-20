//
//  SplashViewController.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import SnapKit
import GoogleSignIn

class SplashViewController: ViewController<SplashViewModel>, GIDSignInUIDelegate {
    let Label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        Label.textAlignment = .center
        Label.text = "To Do List"
        
        view.addSubview(Label)
        Label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let ai = UIActivityIndicatorView.init(style: .gray)
        ai.startAnimating()
        ai.center = view.center
        ai.center.y = ai.center.y + 45
        view.addSubview(ai)
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        viewModel.services.user.completionHandler = {
            (result) in
            if result {
                self.viewModel.moveToTask()
            } else {
                self.viewModel.moveToLogin()
            }
        }
        
        viewModel.services.facebookAuth.checkAuthorization({result  in
            guard !self.viewModel.viewDidAppearCalled else {
                return
            }
            if result {
                self.viewModel.services.user.user.IDs.facebookID = self.viewModel.services.facebookAuth.userID
                self.viewModel.moveToTask()
            } else {
                self.checkGoogleAuth()
            }
            self.viewModel.viewDidAppearCalled = true
        })
        
    }
    
    func checkGoogleAuth() {
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        viewModel.services.googleAuth.checkAuthorization { (result) in
            if result {
                self.viewModel.moveToTask()
            } else {
                self.viewModel.moveToLogin()
            }
        }
    }
    
}
