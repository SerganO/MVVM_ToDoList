//
//  Services.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation

class Services {
    let sceneCoordinator: SceneCoordinator
    let database: DatabaseService
    let tasks: TasksService
    let date: DateService
    public init(sceneCoordinator: SceneCoordinator) {
        self.sceneCoordinator = sceneCoordinator
        database = FirebaseDatabaseService()
        tasks = FirebaseTasksService()
        date = SimpleDateService()
    }
}
