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
    
    func getUserUUID() -> String
    
    
}
