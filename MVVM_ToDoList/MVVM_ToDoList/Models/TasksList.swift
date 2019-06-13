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

class TasksList {
    static let shared = TasksList()
    let completedTasks: BehaviorRelay<[TaskModel]> = BehaviorRelay(value:[])
    let uncompletedTasks: BehaviorRelay<[TaskModel]> = BehaviorRelay(value:[])
    
    
    
    
    
    
    
    public let dataSource: Observable<[TaskModel]>
    init() {
        
        self.dataSource = uncompletedTasks.asObservable()
        
    }
}
