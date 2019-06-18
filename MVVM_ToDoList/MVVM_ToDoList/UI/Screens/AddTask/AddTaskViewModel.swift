//
//  AddTaskViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/13/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class AddTaskViewModel: ViewModel {
    
    var taskForEdit: TaskModel?
    
    func createTask(_ text: String) -> TaskModel {
        
        let task = TaskModel()
        
        task.text = text
        
        print("Task Create")
        print(task.toDic())
        return task
    }
    
    func addTask(_ task: TaskModel) {
        services.tasks.addTask(task, for: services.user.getUserUUID())
    }
    
    func editTask(_ task:TaskModel) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        services.tasks.editTask(task, editItems: [
            ["text": task.text],
            ["createDate": formatter.string(from: Date())]
            ], for: services.user.getUserUUID())
        if let notDate = task.notificationDate {
            services.tasks.editTask(task, editItems: [
                ["notificationDate": formatter.string(from: notDate)]
                ], for: services.user.getUserUUID())
        } else {
            services.tasks.editTask(task, editItems: [
                ["notificationDate": ""]
                ], for: services.user.getUserUUID())
        }
        
    }
    
    override init(services: Services) {
        super.init(services: services)
    }
    
    init(services: Services, taskForEdit: TaskModel) {
        super.init(services: services)
        self.taskForEdit = taskForEdit
    }
    
}
