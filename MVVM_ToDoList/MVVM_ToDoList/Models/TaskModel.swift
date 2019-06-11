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
    
    init?(snapshot: DataSnapshot) {
        
        guard
            let value = snapshot.value as? [String:AnyObject],
            let text = value["text"] as? String,
            let createDate = value["createDate"] as? String,
            let notificationDate = value["notificationDate"] as? String,
            let completed = value["completed"] as? Bool,
            let uuid = value["uuid"] as? String,
            let orderID = value["orderID"] as? Int
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
