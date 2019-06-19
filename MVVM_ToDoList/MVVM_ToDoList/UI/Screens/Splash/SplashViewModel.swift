//
//  SplashViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class SplashViewModel: ViewModel {

    var viewDidAppearCalled = false
    
    func moveToLogin() {
        
        services.sceneCoordinator.transition(to: Scene.login(LoginViewModel(services: services)), type: .push, animated: true)
    }
    
    func moveToTask() {
        
        services.user.userIds.facebookID = services.facebookAuth.userID
        services.database.getUserUUID(userID: services.user.userIds.facebookID, type: .facebook, completion: {
            (_) in
            self.services.sceneCoordinator.transition(to: Scene.login(LoginViewModel(services: self.services)), type: .push, animated: true)
            self.services.sceneCoordinator.transition(to: Scene.tasksList(TasksListViewModel(services: self.services)), type: .push, animated: true)
        }).bind(to: services.user.userUuid).disposed(by: disposeBag)
    }
    
    
    
}
