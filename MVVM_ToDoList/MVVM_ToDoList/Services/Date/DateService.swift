//
//  DateService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/17/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DateService {
    
    var LastDate: BehaviorRelay<Date> { get set }
    
    func setDate(_ date: Date)
}
