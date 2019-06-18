//
//  AuthorizationService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation

protocol AuthorizationService {
    var userID: String { get set }
    func checkAuthorization() -> Bool
}
