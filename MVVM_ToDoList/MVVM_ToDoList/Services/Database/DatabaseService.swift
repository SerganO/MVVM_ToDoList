//
//  DatabaseService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/13/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation

protocol DatabaseService {
    func initLocal()
    func initUserRef(_ pathString: String)
    func addTask(_ task:TaskModel)
    func editTask(_ task: TaskModel, editItems:[[String: Any]])
    func deleteTask( _ task: TaskModel)
}
