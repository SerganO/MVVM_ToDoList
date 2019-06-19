//
//  SimpleDateService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/17/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SimpleDateService : DateService {
    var LastDate: BehaviorRelay<Date> = BehaviorRelay<Date>(value: Date())
    
    func setDate(_ date: Date) {
        LastDate.accept(date)
    }
    
    
}
