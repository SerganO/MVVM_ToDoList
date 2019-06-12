//
//  CreateTaskService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase

protocol CreateTaskService {
    func createNewTask(text: String, notificationDate: Date?) -> TaskModel
    func loadTask(snapshot: DataSnapshot) -> TaskModel
}
