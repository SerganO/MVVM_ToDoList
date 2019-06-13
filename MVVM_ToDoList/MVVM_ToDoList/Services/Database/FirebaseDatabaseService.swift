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
            let emptyValue:[TaskModel] = []
            TasksList.shared.uncompletedTasks.accept(emptyValue)
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let task = TaskModel(snapshot: snapshot) {
                    let newValue = [task] + TasksList.shared.uncompletedTasks.value
                    TasksList.shared.uncompletedTasks.accept(newValue)
                }
            }
        }
    }
    
    
    func initUserRef(_ pathString: String) {
        UserRef = MainRef.child("users").child(pathString)
    }
    
    let MainRef = Database.database().reference()
    var UserRef = Database.database().reference(withPath: "users")
    public func editTask(_ task: TaskModel, editItem:[String: Any]) {
        let que = DispatchQueue.global()
        que.async {
            self.UserRef.child("tasks").child(task.uuid!.uuidString).updateChildValues(editItem)
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
