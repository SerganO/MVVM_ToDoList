//
//  TaskViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class TaskViewModel/*: ViewModel*/ {
    private var task: TaskModel
    
    public init(_ task: TaskModel) {
        self.task = task
    }
    
    public var text: String {
        return task.text
    }
    
    public var createDate: Date {
        return task.createDate
    }
    
    public var notificationDate: Date? {
        return task.notificationDate
    }
    
    public var completed: Bool {
        return task.completed
    }
    
    public var completeImage: UIImage {
        return task.completed ? #imageLiteral(resourceName: "Complete") : #imageLiteral(resourceName: "Uncomplete")
    }
    
    public var orderID: Int {
        return task.orderID
    }
    
    public var uuid: UUID? {
        return task.uuid
    }
    
}

extension TaskViewModel {
    public func changeTask(_ task: TaskModel) {
        self.task = task
    }
    
    public func configureTaskCell(_ cell: TaskCell) {
        cell.taskTextLabel.text = text
        cell.taskCompletedImageView.image = completeImage
    }
    
    public func configureTaskCell(_ task: TaskModel, cell: TaskCell) {
        changeTask(task)
        cell.taskTextLabel.text = text
        cell.taskCompletedImageView.image = completeImage
    }
    
}
