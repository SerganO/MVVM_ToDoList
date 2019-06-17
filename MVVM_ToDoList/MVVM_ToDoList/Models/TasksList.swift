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
import RxDataSources
typealias Section = SectionModel<String, TaskModel>


class TasksList {
    static let shared = TasksList()
    let sections = Variable<[Section]>([])
}
