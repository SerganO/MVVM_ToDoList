//
//  UserService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift

protocol UserService {
    var userIds: userIDs { get set }
    var userUuid:Variable<String> { get set }
    func getUserUUID() -> String
    
   // func login( for userID: String, type: userIDType, completion : @escaping (Bool)-> Void) -> Observable<String>
    
}
