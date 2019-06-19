//
//  SimpleUserService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SimpleUserService: UserService {
    var completionHandler: ((Bool) -> Void)?
 
    var userIds = userIDs()
    
    var userUuid:BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    
    let database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
    func getUserUUID() -> String {
        return userUuid.value
    }
    
    
    
    
    
}
