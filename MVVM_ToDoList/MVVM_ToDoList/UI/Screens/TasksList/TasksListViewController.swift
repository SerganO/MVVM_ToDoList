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




class TasksListViewController: ViewController<TasksListViewModel>, UITableViewDelegate, UITableViewDataSource, GIDSignInUIDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var addButton = UIBarButtonItem()
    var logOutButton = UIBarButtonItem()
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
        add.rx.tap.bind {
            self.viewModel.addTask()
            self.tableView.reloadData()
        }.disposed(by: viewModel.disposeBag)
        addButton = UIBarButtonItem.init(customView: add)
        navigationItem.rightBarButtonItem = addButton
        
        let logOut = UIButton()
        logOut.setTitle("LOG OUT", for: .normal)
        logOut.setTitleColor(.black, for: .normal)
        logOut.rx.tap.bind {
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
            
            GIDSignIn.sharedInstance().signOut()
            
            self.viewModel.services.notification.removeAllNotification()
            self.viewModel.services.sceneCoordinator.pop()
            }.disposed(by: viewModel.disposeBag)
        logOutButton = UIBarButtonItem.init(customView: logOut)
        navigationItem.leftBarButtonItem = logOutButton
        
        navigationItem.hidesBackButton = true
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }
        
        viewModel.sections.asDriver().drive(
                tableView.rx.items(dataSource: dataSource)
            ).disposed(by: viewModel.disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
           
            let task = self.viewModel.sections.value[indexPath.section].items[indexPath.row]
            self.viewModel.editTask(task)
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
       
            let task = self.viewModel.sections.value[indexPath.section].items[indexPath.row]
            self.viewModel.deleteTask(task,indexPath: indexPath )
            
            tableView.rx.itemDeleted.subscribe().disposed(by: self.viewModel.disposeBag)
            
            
        })
        
        return [deleteAction,editAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
    
}
