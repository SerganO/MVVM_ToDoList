//
//  TaskModel.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase

class TaskModel {
    var text = ""
    var createDate = Date()
    var notificationDate: Date?
    var completed = false
    var orderID = -1
    var uuid: UUID?
    
    init() {
        uuid = UUID()
    }
    
    init?(dictionary: [String:Any]) {
        
        guard
            let text = dictionary["text"] as? String,
            let createDate = dictionary["createDate"] as? String,
            let notificationDate = dictionary["notificationDate"] as? String,
            let completed = dictionary["completed"] as? Bool,
            let uuid = dictionary["uuid"] as? String,
            let orderID = dictionary["orderID"] as? Int
            else {
                return nil
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        self.text = text
        self.completed = completed
        self.notificationDate = formatter.date(from: notificationDate)
        self.createDate = formatter.date(from: createDate) ?? Date()
        self.uuid = UUID(uuidString: uuid)
        self.orderID = orderID
        
    }
    
    func toDic() -> [String: Any] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        var notDate = ""
        if let nD = notificationDate {
            notDate = formatter.string(from: nD)
        }
        return [
            "text": text,
            "createDate": formatter.string(from: createDate),
            "notificationDate": notDate,
            "completed": completed,
            "uuid": uuid!.uuidString,
            "orderID": orderID
        ]
    }
    
}
