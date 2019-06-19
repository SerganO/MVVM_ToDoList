//
//  LoginViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/18/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation

class LoginViewModel: ViewModel {
    
    func move() {
        services.sceneCoordinator.transition(to: Scene.tasksList(TasksListViewModel(services: services)), type: .push, animated: true)
    }
    
}
