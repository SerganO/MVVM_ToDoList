//
//  ViewController.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import RxSwift
import GoogleSignIn

class ViewController<T: ViewModel>: UIViewController, GIDSignInDelegate {
    
    var viewModel: T
    let disposeBag = DisposeBag()
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            viewModel.services.user.userIds.googleID = user.userID
            viewModel.services.database.getUserUUID(userID: self.viewModel.services.user.userIds.googleID, type: .google, completion: {
                (result) in
                self.viewModel.services.user.navigationCompletion?(result)
            }).bind(to: self.viewModel.services.user.userUuid).disposed(by: self.disposeBag)
        }
    }
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        configure()
    }
    
    func configure() {
        
    }

}

