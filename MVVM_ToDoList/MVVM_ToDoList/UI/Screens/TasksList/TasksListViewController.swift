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




class TasksListViewController: ViewController<TasksListViewModel>, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var addButton = UIBarButtonItem()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TaskModel>>(configureCell: { dataSource, tableView, indexPath, item in
                    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.Identifier, for: indexPath) as! TaskCell
                    TasksListViewModel.configureTaskCell(item, cell: cell)
                    return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let button = UIButton()
        button.setTitle("ADD", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.rx.tap.bind {
            self.viewModel.addTask()
            self.tableView.reloadData()
        }.disposed(by: viewModel.disposeBag)
        addButton = UIBarButtonItem.init(customView: button)
        navigationItem.rightBarButtonItem = addButton
        navigationItem.hidesBackButton = true
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }
        
        TasksListViewModel.initDataSource().map { (customDatas) -> [Section] in
            [Section(model: "Uncompleted", items: []),
             Section(model: "Completed", items: [])]
            }.bind(to: TasksList.shared.sect).disposed(by: viewModel.disposeBag)
        
        TasksList.shared.sect.asDriver().drive(
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
            
            let task = TasksList.shared.sect.value[indexPath.section].items[indexPath.row]
            self.viewModel.editTask(task)
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            let task = TasksList.shared.sect.value[indexPath.section].items[indexPath.row]
            self.viewModel.deleteTask(task,indexPath: indexPath )
        })
        
        return [deleteAction,editAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
