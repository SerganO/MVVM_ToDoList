//
//  SimpleCreateTask.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase

class SimpleCreateTask: CreateTaskService {
    func createNewTask(text: String, notificationDate: Date?) -> TaskModel {
        let task = TaskModel()
        task.text = text
        task.notificationDate = notificationDate
        task.completed = false
        task.createDate = Date()
        task.uuid = UUID()
        task.orderID = 0
        return task
    }
    
    func loadTask(snapshot: DataSnapshot) -> TaskModel {
        let maybeTask = TaskModel(snapshot: snapshot)
        if let task = maybeTask {
            return task
        }
        return TaskModel()
    }
    
    
}
