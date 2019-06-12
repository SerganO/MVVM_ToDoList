//
//  SceneCoordinatorType.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import RxSwift

public protocol SceneCoordinatorType {
    
    func transition(to scene: SceneType, type: SceneTransitionType, animated: Bool) -> Completable
    
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    
    func pop() -> Completable {
        return pop(animated: true)
    }
}

