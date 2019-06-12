//
//  TasksListViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation

class TasksListViewModel: ViewModel {
    
    let compleatedTasks: [TaskModel] = [TaskModel(), TaskModel(), TaskModel(), TaskModel()]
    let uncompleatedTasks: [TaskModel] = [TaskModel(), TaskModel(), TaskModel()]
    let taskViewModel = TaskViewModel(TaskModel())
    
    func configureTaskCell(_ cell: TaskCell, section: Int, row: Int) {
        if section == 0 {
            taskViewModel.configureTaskCell(uncompleatedTasks[row], cell: cell)
        } else {
            taskViewModel.configureTaskCell(compleatedTasks[row], cell: cell)
        }
    }
    
    func addTask() {
        
    }
    
}
