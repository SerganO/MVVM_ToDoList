//
//  TasksService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/17/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift

protocol TasksService {
    func tasks(for userID: String) -> Observable<[Section]>
    func addTask(_ task: TaskModel, for userID: String)
    func editTask(_ task: TaskModel, editItems:[[String: Any]], for userID: String)
    func deleteTask( _ task: TaskModel, for userID: String)
}
