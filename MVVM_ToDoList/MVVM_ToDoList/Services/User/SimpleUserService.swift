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
    func getUserUUID(userID: String, type: userIDType, completion: @escaping (Bool) -> Void) -> Observable<String> {
        return database.getUserUUID(userID: userID, type: type, completion: completion)
    }
    
    func syncUserID(newUserID: String, newType: userIDType, with uuid: String, completion: @escaping (Bool) -> Void) {
        database.syncUserID(newUserID: newUserID, newType: newType, with: uuid, completion: completion)
    }
    
    func getSync(for uuid: String, completion: @escaping (Bool) -> Void) {
        database.getSync(for: uuid, completion: completion)
    }
    
    var user: User = User()
    
    var completionHandler: ((Bool) -> Void)?
    
    
    let database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
    
    
    
    
}
