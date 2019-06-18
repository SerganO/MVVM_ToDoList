//
//  SimpleTasksService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/17/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class FirebaseTasksService: TasksService {
    
    
    let database = FirebaseDatabaseService()
    
    
    func tasks(for userID: String) -> Observable<[Section]> {
        return database.tasks(for: userID)
    }
    
    func addTask(_ task: TaskModel, for userID: String) {
        database.addTask(task, for: userID)
    }
    
    func editTask(_ task: TaskModel, editItems: [[String : Any]], for userID: String) {
        database.editTask(task, editItems: editItems, for: userID)
    }
    
    func deleteTask(_ task: TaskModel, for userID: String) {
        database.deleteTask(task, for: userID)
    }
    
    
    
    
}
