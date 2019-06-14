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
    
    static func configureTaskCell(_ task:TaskModel, cell: TaskCell) {
        cell.taskTextLabel.text = task.text
        cell.taskCompletedImageView.image = task.completed ? #imageLiteral(resourceName: "Complete") : #imageLiteral(resourceName: "Uncomplete")
    }
    
    static func initDataSource() -> Observable<[TaskModel]> {
        return .just([])
    }
    
    func addTask() {
        print("ADD")
        services.sceneCoordinator.transition(to: Scene.addTask(AddTaskViewModel(services: services)), type: .push, animated: true)
    }
    
    func editTask(_ task : TaskModel) {
        print("Edit")
        services.sceneCoordinator.transition(to: Scene.addTask(AddTaskViewModel(services: services, taskForEdit: task)), type: .push, animated: true)
    }
    
    func deleteTask(_ task: TaskModel, indexPath: IndexPath) {
        print("Delete")
        services.database.deleteTask(task)
        TasksList.shared.sect.value[indexPath.section].items.remove(at: indexPath.row)
    }
    
    func selectCell(_ cell: TaskCell, indexPath: IndexPath) {
        let task = TasksList.shared.sect.value[indexPath.section].items[indexPath.row]
        task.completed = !task.completed
        TasksListViewModel.configureTaskCell(task, cell: cell)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        services.database.editTask(task, editItems: [["completed":task.completed ? 1 : 0],["createDate":formatter.string(from: Date())]])
    }
    
    
    
}
