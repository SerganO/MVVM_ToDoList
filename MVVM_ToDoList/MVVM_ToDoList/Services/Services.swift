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
    let notification: NotificationService
    var facebookAuth: AuthorizationService
    let user: UserService
    
    public init(sceneCoordinator: SceneCoordinator) {
        self.sceneCoordinator = sceneCoordinator
        database = FirebaseDatabaseService()
        tasks = SimpleTasksService(database: database)
        date = SimpleDateService()
        notification = SimpleNotificationService()
        facebookAuth = FacebookAuthorizationService()
        user = SimpleUserService(database: database)
    }
}
