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
    
    
    
//    func login(for userID: String, type: userIDType, completion : @escaping (Bool)-> Void) -> Observable<String> {
////        database.getUserUUID(userID: userID, type: type, completion: completion).subscribe(onNext: { (uuid) in
////            self.userUuid.value = uuid
////        }).disposed(by: DisposeBag())
//        
////        database.getUserUUID(userID: userID, type: type, completion: completion).subscribe({ (event) in
////            if let uuid = event.element {
////                self.userUuid.value = uuid
////            }
////        }).disposed(by: DisposeBag())
//        
//        database.getUserUUID(userID: userID, type: type, completion: completion).bind(to: userUuid).disposed(by: DisposeBag())
//        
//    }
    
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
