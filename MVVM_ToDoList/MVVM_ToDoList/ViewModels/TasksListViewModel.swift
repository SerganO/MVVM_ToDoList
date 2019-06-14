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
        taskViewModel.configureTaskCell(TasksList.shared.sections[section].items[row], cell: cell)
    }
    
    func addTask() {
        print("ADD")
        services.sceneCoordinator.transition(to: Scene.addTask(AddTaskViewModel(services: services)), type: .push, animated: true)
    }
    
    func selectCell(_ cell: TaskCell, indexPath: IndexPath) {
        let task =  TasksList.shared.sections[indexPath.section].items[indexPath.row]
        task.completed = !task.completed
        taskViewModel.changeTask(task)
        configureTaskCell(cell, section: indexPath.section, row: indexPath.row)
        services.database.editTask(task, editItem: ["completed":task.completed ? 1 : 0])
    }
    
    
}
