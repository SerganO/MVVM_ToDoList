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
        services.database.addTask(task)
        TasksList.shared.sections.value[0].items.append(task)
    }
    
    func editTask(_ task:TaskModel) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        services.database.editTask(task, editItems: [
            ["text": task.text],
            ["createDate": formatter.string(from: Date())]
            ])
    }
    
    override init(services: Services) {
        super.init(services: services)
    }
    
    init(services: Services, taskForEdit: TaskModel) {
        super.init(services: services)
        self.taskForEdit = taskForEdit
    }
    
}
