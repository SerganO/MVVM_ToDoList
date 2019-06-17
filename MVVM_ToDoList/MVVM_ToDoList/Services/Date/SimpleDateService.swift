//
//  SimpleDateService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/17/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift

class SimpleDateService : DateService {
    var LastDate: Variable<Date> = Variable<Date>(Date())
    
    func setDate(_ date: Date) {
        LastDate.value = date
    }
    
    
}
