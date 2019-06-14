//
//  FirebaseDatabaseService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/13/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDatabaseService: DatabaseService {
    func initLocal() {
        UserRef.child("tasks").queryOrdered(byChild: "createDate").observe(.value) { (snapshot) in
            TasksList.shared.sect.value[0].items.removeAll()
            TasksList.shared.sect.value[1].items.removeAll()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let task = TaskModel(snapshot: snapshot) {
                    if task.completed {
                        TasksList.shared.sect.value[1].items.insert(task, at: 0)
                    } else {
                        TasksList.shared.sect.value[0].items.insert(task, at: 0)
                    }
                }
            }
        }
    }
    
    
    func initUserRef(_ pathString: String) {
        UserRef = MainRef.child("users").child(pathString)
    }
    
    let MainRef = Database.database().reference()
    var UserRef = Database.database().reference(withPath: "users")
    
    public func editTask(_ task: TaskModel, editItems:[[String: Any]]) {
        let que = DispatchQueue.global()
        que.async {
            
            for editItem in editItems {
                self.UserRef.child("tasks").child(task.uuid!.uuidString).updateChildValues(editItem)
            }
        }
    }
    public func deleteTask(_ task: TaskModel) {
        let que = DispatchQueue.global()
        que.async {
            self.UserRef.child("tasks").child(task.uuid!.uuidString).removeValue()
        }
    }
    
    public func addTask(_ task: TaskModel)
    {
        let que = DispatchQueue.global()
        que.async {
            let taskRef = self.UserRef.child("tasks").child(task.uuid!.uuidString)
            taskRef.setValue(task.toDic())
        }
        
        
        
    }
    
    
}
