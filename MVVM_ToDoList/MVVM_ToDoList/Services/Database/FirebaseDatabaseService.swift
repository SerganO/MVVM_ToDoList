//
//  FirebaseDatabaseService.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/13/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase
import RxSwift


class FirebaseDatabaseService: DatabaseService {
    
    
    let MainRef = Database.database().reference()
    func checkUser(userID: String, type: userIDType) -> Observable<Bool> {
        
        var typeString = ""
        
        switch type {
        case .facebook:
            typeString = "FacebookID"
            break
        case .google:
            typeString = "GoogleID"
            break
        case .none:
            break
        }
        
        return Observable.create({ (observer) -> Disposable in
            self.MainRef.child("Identifier").child(typeString).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                if snapshot.exists() {
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            })
            return Disposables.create()
        })
    }
    
    
    
    func tasks(for userID: String) -> Observable<[Section]> {
        
        return Observable.create({ (observer) -> Disposable in
            let UserRef = self.MainRef.child("users").child(userID)
            UserRef.child("tasks").queryOrdered(byChild: "createDate").observe(.value) { (snapshot) in
                var newTasks = [Section(model: "Uncompleted", items: []), Section(model: "Completed", items: [])]
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let task = TaskModel(dictionary: snapshot.value as? [String: Any] ?? [:]) {
                        if task.completed {
                            newTasks[1].items.insert(task, at: 0)
                        } else {
                            newTasks[0].items.insert(task, at: 0)
                        }
                    }
                    observer.onNext(newTasks)
                }
            }
            
            return Disposables.create()
        })
    }
    
    
    public func addTask(_ task: TaskModel, for userID: String)
    {
        let que = DispatchQueue.global()
        que.async {
            let UserRef = self.MainRef.child("users").child(userID)
            let taskRef = UserRef.child("tasks").child(task.uuid!.uuidString)
            taskRef.setValue(task.toDic())
        }
    }
    
    public func editTask(_ task: TaskModel, editItems:[[String: Any]], for userID: String) {
        let que = DispatchQueue.global()
        que.async {
            for editItem in editItems {
                let UserRef = self.MainRef.child("users").child(userID)
                UserRef.child("tasks").child(task.uuid!.uuidString).updateChildValues(editItem)
            }
        }
    }
    
    public func deleteTask(_ task: TaskModel, for userID: String) {
        let que = DispatchQueue.global()
        que.async {
            let UserRef = self.MainRef.child("users").child(userID)
            UserRef.child("tasks").child(task.uuid!.uuidString).removeValue()
        }
    }
    
}
