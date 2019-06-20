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
    
    var user: User {get set}
    var completionHandler: ((Bool) -> Void)? { get set }
    
    func getUserUUID(userID: String, type: userIDType, completion : @escaping (Bool)-> Void) -> Observable<String>
    func syncUserID(newUserID: String, newType: userIDType, with uuid: String, completion : @escaping (Bool)-> Void)
    func getSync(for uuid:String, completion : @escaping (Bool)-> Void) 
}
