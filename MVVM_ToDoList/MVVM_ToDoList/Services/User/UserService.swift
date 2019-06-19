//
//  UserService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserService {
    var userIds: userIDs { get set }
    var userUuid:BehaviorRelay<String> { get set }
    func getUserUUID() -> String
    var completionHandler: ((Bool) -> Void)? { get set }
   // func login( for userID: String, type: userIDType, completion : @escaping (Bool)-> Void) -> Observable<String>
    
}
