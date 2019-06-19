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
    var navigationCompletion: ((Bool) -> Void)?
 
    var userIds = userIDs()
    
    var userUuid:Variable<String> = Variable<String>("")
    
    
    let database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
    func getUserUUID() -> String {
        return userUuid.value
    }
    
    
    
    
    
}
