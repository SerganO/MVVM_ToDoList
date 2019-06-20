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
        if services.user.user.IDs.facebookID != "" {
            services.user.user.IDs.facebookID = services.facebookAuth.userID
            services.user.getUserUUID(userID: services.user.user.IDs.facebookID, type: .facebook, completion: {
                (_) in
                self.services.user.getSync(for: self.services.user.user.getUserUUID(), completion: { (result) in
                    self.services.user.user.sync = result
                    self.services.sceneCoordinator.transition(to: Scene.login(LoginViewModel(services: self.services)), type: .push, animated: true)
                    self.services.sceneCoordinator.transition(to: Scene.tasksList(TasksListViewModel(services: self.services)), type: .push, animated: true)
                })
                
            }).bind(to: services.user.user.uuid).disposed(by: disposeBag)
        } else if services.user.user.IDs.googleID != "" {
            services.user.getUserUUID(userID: self.services.user.user.IDs.googleID, type: .google, completion: {
                (_) in
                self.services.user.getSync(for: self.services.user.user.getUserUUID(), completion: { (result) in
                    self.services.user.user.sync = result
                    self.services.sceneCoordinator.transition(to: Scene.login(LoginViewModel(services: self.services)), type: .push, animated: true)
                    self.services.sceneCoordinator.transition(to: Scene.tasksList(TasksListViewModel(services: self.services)), type: .push, animated: true)
                })
            }).bind(to: self.services.user.user.uuid).disposed(by: self.disposeBag)
        }
    }
    
    
    
}
