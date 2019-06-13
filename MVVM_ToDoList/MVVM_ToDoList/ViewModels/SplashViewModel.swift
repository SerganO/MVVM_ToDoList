//
//  SplashViewModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class SplashViewModel: ViewModel {
    /*init(services: Services) {
        super.init(services: services)
    }*/
    
    func move() {
        sleep(2)
        
        services.sceneCoordinator.transition(to: Scene.tasksList(TasksListViewModel(services: services)), type: .push, animated: true)
    }
}
