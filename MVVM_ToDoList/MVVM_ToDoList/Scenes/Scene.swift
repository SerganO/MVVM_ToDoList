//
//  Scene.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

enum Scene {
    //case task
    //case addTask
    //case editTask
    //case login
    case splash(SplashViewModel)
    case navigation(NavigationViewModel)
    //case date
    case tasksList(TasksListViewModel)
}


extension Scene: SceneType {
    
    public func viewController() -> UIViewController {
        switch self {
            
        case .splash(let viewModel):
            return SplashViewController(viewModel: viewModel)
        
        case .tasksList(let viewModel):
            return TasksListViewController(viewModel: viewModel)
            
        case .navigation (let viewModel):
            return NavigationController(viewModel: viewModel)
            
        }
        
    }
}
