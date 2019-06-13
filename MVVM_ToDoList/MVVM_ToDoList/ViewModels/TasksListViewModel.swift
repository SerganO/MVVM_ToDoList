//
//  TasksListViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TasksListViewModel: ViewModel {
    
    let taskViewModel = TaskViewModel(TaskModel())
    
    let Tasks = Observable.just(TaskModel())
    
    func configureTaskCell(_ cell: TaskCell, section: Int, row: Int) {
        if section == 0 {
            taskViewModel.configureTaskCell(TasksList.shared.uncompletedTasks.value[row], cell: cell)
        } else {
            taskViewModel.configureTaskCell(TasksList.shared.completedTasks.value[row], cell: cell)
        }
    }
    
    func addTask() {
        print("ADD")
        services.sceneCoordinator.transition(to: Scene.addTask(AddTaskViewModel(services: services)), type: .push, animated: true)
    }
    
    func selectCell(_ cell: TaskCell, indexPath: IndexPath) {
        let task = indexPath.section == 0 ? TasksList.shared.uncompletedTasks.value[indexPath.row] : TasksList.shared.completedTasks.value[indexPath.row]
        task.completed = !task.completed
        taskViewModel.changeTask(task)
        configureTaskCell(cell, section: indexPath.section, row: indexPath.row)
        services.database.editTask(task, editItem: ["completed":task.completed ? 1 : 0])
    }
    
    
}
