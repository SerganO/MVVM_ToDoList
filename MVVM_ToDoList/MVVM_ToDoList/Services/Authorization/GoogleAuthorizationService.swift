//
//  GoogleAuthorizationService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleAuthorizationService: AuthorizationService {
  
    let database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
    var userID: String = ""
    
    func checkAuthorization() -> Bool {
        if let result = GIDSignIn.sharedInstance()?.hasAuthInKeychain(), result {
            GIDSignIn.sharedInstance()?.signIn()
            if let clientID = GIDSignIn.sharedInstance()?.currentUser?.userID {
                userID = clientID
            }
            return true
        } else {
            return false
        }
    }
    
    
    
    
}
