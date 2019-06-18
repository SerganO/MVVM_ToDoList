//
//  SplashViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class SplashViewModel: ViewModel {

    func moveToLogin() {
        sleep(2)
        
        services.sceneCoordinator.transition(to: Scene.login(LoginViewModel(services: services)), type: .push, animated: true)
    }
    
    func moveToTask() {
        sleep(2)
        services.user.userIds.facebookID = services.facebookAuth.userID
        services.sceneCoordinator.transition(to: Scene.login(LoginViewModel(services: services)), type: .push, animated: true)
        services.sceneCoordinator.transition(to: Scene.tasksList(TasksListViewModel(services: services)), type: .push, animated: true)
       
        
    }
    
    
    
}
