//
//  FacebookAuthorizationService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookAuthorizationService: AuthorizationService {
    
    var userID: String = ""
    
    func checkAuthorization() -> Bool {
        if let accessToken = FBSDKAccessToken.current(), FBSDKAccessToken.currentAccessTokenIsActive() {
            userID = accessToken.userID
            return true
        }
        return false
    }
    
    
}
