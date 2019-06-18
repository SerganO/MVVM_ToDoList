//
//  SimpleUserService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift

class SimpleUserService: UserService {
    var userIds = userIDs()
    
    var userUuid: String = ""
    
    
    let database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
    func getUserUUID() -> String {
        var userID = ""
        var type: userIDType = .none
        if userIds.facebookID != "" {
            userID = userIds.facebookID
            type = .facebook
        }
        if userIds.googleID != "" {
            userID = userIds.googleID
            type = .google
        }
        
      return userID
    }
    
    
}
