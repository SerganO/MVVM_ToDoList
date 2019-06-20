//
//  TasksListViewController.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn



class TasksListViewController: ViewController<TasksListViewModel>, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var addButton = UIBarButtonItem()
    var syncButton = UIBarButtonItem()
    var logOutButton = UIBarButtonItem()
    var reorderButton = UIBarButtonItem()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TaskModel>>(configureCell: { dataSource, tableView, indexPath, item in
                    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.Identifier, for: indexPath) as! TaskCell
                    TasksListViewModel.configureTaskCell(item, cell: cell)
                    return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "To Do List"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let add = UIButton()
        add.setTitle("ADD", for: .normal)
        add.setTitleColor(.black, for: .normal)
        add.setTitleColor(.gray, for: .highlighted)
        add.rx.tap.bind {
            self.addButtonTap()
        }.disposed(by: viewModel.disposeBag)
        addButton = UIBarButtonItem.init(customView: add)
        navigationItem.rightBarButtonItem = addButton
        
        
        let reorder = UIButton()
        reorder.setImage(UIImage(named:"Reorder"), for: .normal)
        reorder.rx.tap.bind {
            self.reorderButtonTap()
        }.disposed(by: viewModel.disposeBag)
        
        let reorderButton = UIBarButtonItem(customView: reorder)
        navigationItem.rightBarButtonItems?.append(reorderButton)
        
        
        
       
        
        let logOut = UIButton()
        logOut.setTitle("LOG OUT", for: .normal)
        logOut.setTitleColor(.black, for: .normal)
        logOut.setTitleColor(.gray, for: .highlighted)
        logOut.rx.tap.bind {
                self.logOutButtonTap()
            }.disposed(by: viewModel.disposeBag)
        logOutButton = UIBarButtonItem.init(customView: logOut)
        navigationItem.leftBarButtonItem = logOutButton
        
        let sync = UIButton()
        
        if viewModel.services.user.user.sync {
            sync.setImage(UIImage(named:"AllDone"), for: .normal)
        } else if viewModel.services.user.user.IDs.facebookID == "" {
            sync.setImage(UIImage(named:"Facebook"), for: .normal)
        } else {
            sync.setImage(UIImage(named:"GoogleIcon"), for: .normal)
        }
        
        sync.setTitleColor(.black, for: .normal)
        sync.setTitleColor(.gray, for: .highlighted)
        sync.rx.tap.bind {
            self.syncButtonTap()
            }.disposed(by: viewModel.disposeBag)
        syncButton = UIBarButtonItem.init(customView: sync)
        navigationItem.leftBarButtonItems?.append(syncButton)
        
        navigationItem.hidesBackButton = true
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        dataSource.canEditRowAtIndexPath = { _, indexPath in
            let cell = self.tableView.cellForRow(at: indexPath)
            cell?.showsReorderControl = false
            return true
        }
        
        dataSource.canMoveRowAtIndexPath = {_,_ in
            return true
        }
        
        viewModel.sections.asDriver().drive(
                tableView.rx.items(dataSource: dataSource)
            ).disposed(by: viewModel.disposeBag)
        
    }
    func reorderButtonTap() {
        viewModel.updateId()
        tableView.isEditing = !tableView.isEditing
    }
    
    
    
    
    func addButtonTap() {
        viewModel.updateId()
        viewModel.addTask()
        tableView.reloadData()
    }
    
    func syncButtonTap() {
        guard !viewModel.services.user.user.sync else { return }
        
        if viewModel.services.facebookAuth.userID == "" {
            let loginManager = LoginManager()
            loginManager.loginBehavior = .web
            loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: nil, completion: { (LoginResult) in
                if let accessToken = FBSDKAccessToken.current(), FBSDKAccessToken.currentAccessTokenIsActive() {
                    self.viewModel.services.facebookAuth.userID = accessToken.userID
                    self.viewModel.services.user.syncUserID(newUserID: accessToken.userID, newType: .facebook, with: self.viewModel.services.user.user.getUserUUID(), completion: { (result) in
                        if result {
                            self.viewModel.services.user.getSync(for: self.viewModel.services.user.user.getUserUUID(), completion: { (result) in
                                self.viewModel.services.user.user.sync = result
                                if let button = self.syncButton.customView as? UIButton {
                                    button.setImage(UIImage(named:"AllDone"), for: .normal)
                                }
                            })
                        }
                    })
                }
                
            })
        } else if viewModel.services.googleAuth.userID == "" {
            viewModel.services.user.completionHandler = {
                (result) in
                if result {
                    self.viewModel.services.database.syncUserID(newUserID: self.viewModel.services.googleAuth.userID, newType: .google, with: self.viewModel.services.user.user.getUserUUID(), completion: { (result) in
                        if result {
                            self.viewModel.services.user.getSync(for: self.viewModel.services.user.user.getUserUUID(), completion: { (result) in
                                self.viewModel.services.user.user.sync = result
                                if let button = self.syncButton.customView as? UIButton {
                                    button.setImage(UIImage(named:"AllDone"), for: .normal)
                                }
                            })
                        }
                    })
                }
                
            }
            GIDSignIn.sharedInstance()?.signIn()
        }
        
    }
    
    func logOutButtonTap() {
        let loginManager = LoginManager()
        loginManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        let cookies = HTTPCookieStorage.shared
        var facebookCookies = cookies.cookies(for: URL(string: "http://login.facebook.com")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }
        facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        GIDSignIn.sharedInstance()?.signOut()
        viewModel.services.facebookAuth.userID = ""
        viewModel.services.googleAuth.userID = ""
        
        viewModel.services.notification.removeAllNotification()
        viewModel.services.sceneCoordinator.pop()
    }
    
    override func configure() {
        super.configure()
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.Identifier)
        tableView.delegate = self
        configureReactiveTableView()
    }
    
    func configureReactiveTableView() {
        tableView.rx.itemSelected.subscribe(onNext: {
            [unowned self] indexPath in
            guard let cell = self.tableView.cellForRow(at: indexPath) as? TaskCell else {
                return
            }
            
            self.viewModel.selectCell(cell, indexPath: indexPath)
            
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            } 
        }).disposed(by: disposeBag)
        
        tableView.rx.itemMoved.subscribe(onNext: { (movePath) in
            
            let (sourceIndexPath, destinationIndexPath) = movePath
            if(sourceIndexPath.section == destinationIndexPath.section) {
                if sourceIndexPath.section == 0 {
                    var uncheckedGroup = self.viewModel.sections.value
                    let itemToMove = uncheckedGroup[0].items[sourceIndexPath.row]
                    uncheckedGroup[0].items.remove(at: sourceIndexPath.row)
                    uncheckedGroup[0].items.insert(itemToMove, at: destinationIndexPath.row)
                    self.viewModel.sections.accept(uncheckedGroup)
                } else {
                    var checkedGroup = self.viewModel.sections.value
                    let itemToMove = checkedGroup[1].items[sourceIndexPath.row]
                    checkedGroup[1].items.remove(at: sourceIndexPath.row)
                    checkedGroup[1].items.insert(itemToMove, at: destinationIndexPath.row)
                    self.viewModel.sections.accept(checkedGroup)
                }
            } else  {
                    let task = self.viewModel.sections.value[sourceIndexPath.section].items[sourceIndexPath.row]
                    self.viewModel.services.tasks.editTask(task, editItems: [["text":""],["text":task.text]], for: self.viewModel.services.user.user.getUserUUID())
                self.tableView.reloadData()
            }
        }).disposed(by: viewModel.disposeBag)
        
    }
    
    
    
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.Identifier, for: indexPath) as! TaskCell
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            self.viewModel.updateId()
            let task = self.viewModel.sections.value[indexPath.section].items[indexPath.row]
            self.viewModel.editTask(task)
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            self.viewModel.updateId()
            let task = self.viewModel.sections.value[indexPath.section].items[indexPath.row]
            self.viewModel.deleteTask(task,indexPath: indexPath )
            
            tableView.rx.itemDeleted.subscribe().disposed(by: self.viewModel.disposeBag)
            
        })
        
        return [deleteAction,editAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if(sourceIndexPath.section == destinationIndexPath.section) {
            if sourceIndexPath.section == 0 {
                var uncheckedGroup = viewModel.sections.value
                let itemToMove = uncheckedGroup[0].items[sourceIndexPath.row]
                uncheckedGroup[0].items.remove(at: sourceIndexPath.row)
                uncheckedGroup[0].items.insert(itemToMove, at: destinationIndexPath.row)
                viewModel.sections.accept(uncheckedGroup)
            } else {
                var checkedGroup = viewModel.sections.value
                let itemToMove = checkedGroup[1].items[sourceIndexPath.row]
                checkedGroup[1].items.remove(at: sourceIndexPath.row)
                checkedGroup[1].items.insert(itemToMove, at: destinationIndexPath.row)
                viewModel.sections.accept(checkedGroup)
            }
        } else {
            tableView.reloadData()
        }
    }
    
//    public var itemMoved: ControlEvent<ItemMovedEvent> {
//        let source: Observable<ItemMovedEvent> = self.dataSource.methodInvoked(#selector(UITableViewDataSource.tableView(_:moveRowAt:to:)))
//            .map { a in
//                return (try castOrThrow(IndexPath.self, a[1]), try castOrThrow(IndexPath.self, a[2]))
//        }
//
//        return ControlEvent(events: source)
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
    
}
