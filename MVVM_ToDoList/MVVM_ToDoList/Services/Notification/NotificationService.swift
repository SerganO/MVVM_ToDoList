//
//  NotificationService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation

protocol NotificationService {
    func allowNotification()
    func addNotification(for task: TaskModel)
    func removeNotification(for task: TaskModel)
    func removeAllNotification()
    func syncNotification(for tasks: [TaskModel])
}
