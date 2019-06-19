//
//  DatabaseService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/13/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift

protocol DatabaseService {
    func tasks(for userID: String) -> Observable<[Section]>
    func addTask(_ task: TaskModel, for userID: String)
    func editTask(_ task: TaskModel, editItems:[[String: Any]], for userID: String)
    func deleteTask( _ task: TaskModel, for userID: String)
    
    func getUserUUID(userID: String, type: userIDType, completion : @escaping (Bool)-> Void) -> Observable<String>
    func syncUserID(newUserID: String, newType: userIDType, with uuid: String, completion : @escaping (Bool)-> Void)
    
}
