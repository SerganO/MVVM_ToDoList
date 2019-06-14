//
//  CustomSection.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/14/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxDataSources

struct CustomSection {
    var header: String
    var items: [TaskModel]
}
extension CustomSection: SectionModelType {
    typealias Item = TaskModel
    
    init(original: CustomSection, items: [TaskModel]) {
        self = original
        self.items = items
    }
}
