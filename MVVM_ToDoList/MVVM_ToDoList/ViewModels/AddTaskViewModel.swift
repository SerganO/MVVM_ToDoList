//
//  AddTaskViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/13/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation

class AddTaskViewModel: ViewModel {
    
    func createTask(_ text: String) -> TaskModel {
        
        let task = TaskModel()
        
        task.text = text
        
        print("Task Create")
        print(task.toDic())
        return task
    }
    
    func addTask(_ task: TaskModel) {
        
        //services.database.addTask(task)
        //TasksList.shared.sections[0].items.append(task)
        //TasksList.shared.items
        
        let newValue = [task] + TasksList.shared.uncompletedTasks.value
        TasksList.shared.uncompletedTasks.accept(newValue)
        //TasksList.shared.uncompletedTasks.value.append(task)
        
        
    }
    
}
