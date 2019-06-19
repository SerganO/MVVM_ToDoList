//
//  GoogleAuthorizationService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/19/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleAuthorizationService: AuthorizationService {
    var userID: String = ""
    
    func checkAuthorization(_ completion : @escaping (Bool)-> Void){
        if let result = GIDSignIn.sharedInstance()?.hasAuthInKeychain(), result {
            print("Yes has")
            GIDSignIn.sharedInstance()?.signIn()
            completion(true)
        } else {
            print("No")
            completion(false)
        }
    }
    
    
}
