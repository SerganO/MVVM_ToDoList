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
    
    //let Tasks = Observable.just(TaskModel())
    
    func configureTaskCell(_ cell: TaskCell, indexPath: IndexPath) {
        taskViewModel.configureTaskCell(TasksList.shared.sect.value[indexPath.section].items[indexPath.row], cell: cell)
    }
    
    func addTask() {
        print("ADD")
        services.sceneCoordinator.transition(to: Scene.addTask(AddTaskViewModel(services: services)), type: .push, animated: true)
    }
    
    func editTask(_ task : TaskModel) {
        print("Edit")
        services.sceneCoordinator.transition(to: Scene.addTask(AddTaskViewModel(services: services, taskForEdit: task)), type: .push, animated: true)
    }
    
    func selectCell(_ cell: TaskCell, indexPath: IndexPath) {
        let task =   TasksList.shared.sect.value[indexPath.section].items[indexPath.row]
        task.completed = !task.completed
        taskViewModel.changeTask(task)
        configureTaskCell(cell, indexPath: indexPath)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        services.database.editTask(task, editItems: [["completed":task.completed ? 1 : 0],["createDate":formatter.string(from: Date())]])
        //services.database.editTask(task, editItems: )
        
    }
    
    
}
