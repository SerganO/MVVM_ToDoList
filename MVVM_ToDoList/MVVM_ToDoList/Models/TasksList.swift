//
//  TasksList.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/13/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class TasksList {
    static let shared = TasksList()
    let completedTasks: BehaviorRelay<[TaskModel]> = BehaviorRelay(value:[])
    let uncompletedTasks: BehaviorRelay<[TaskModel]> = BehaviorRelay(value:[])
    
    var sections = [SectionModel<String,TaskModel>(model: "Uncompleted", items: [TaskModel()]), SectionModel<String,TaskModel>(model: "Completed", items: [TaskModel(),TaskModel()]) ]
    
    var items: Observable<[SectionModel<String,TaskModel>]>
    
    init() {
        items = Observable.just(sections)
    }
    
    func update() {
        items = Observable.just(sections)
    }
    
}
