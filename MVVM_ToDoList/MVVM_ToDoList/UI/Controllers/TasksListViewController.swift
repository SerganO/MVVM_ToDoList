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

enum Api {
    /// Network response
    static func call() -> Observable<[TaskModel]> {
        return .just([TaskModel()])
    }
}


class TasksListViewController: ViewController<TasksListViewModel>, UITableViewDelegate, UITableViewDataSource {
    
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var addButton = UIBarButtonItem()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TaskModel>>(configureCell: { dataSource, tableView, indexPath, item in
                    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.Identifier, for: indexPath) as! TaskCell
                    cell.taskTextLabel.text = item.text
                    cell.taskCompletedImageView.image = item.completed ? #imageLiteral(resourceName: "Complete") : #imageLiteral(resourceName: "Uncomplete")
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
        
//        TasksList.shared.items
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: viewModel.disposeBag)
        
        Api.call().map { (customDatas) -> [Section] in
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
        //tableView.dataSource = self
        tableView.delegate = self
//        tableView.isEditing = false
//        self.setEditing(false, animated: true)
        //tableView.rx.setDelegate(self)
        
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
            }         }).disposed(by: disposeBag)
        
        

        
        //TasksList.shared.uncompletedTasks.bind(to: tableView.dataSource)
        /*TasksList.shared.dataSource
            .bind(to: tableView.rx.items(cellIdentifier: TaskCell.Identifier, cellType: TaskCell.self)) {  row, element, cell in
                //cell.textLabel?.text = "\(element.text) \(row)"
                self.viewModel.taskViewModel.changeTask(element)
                self.viewModel.configureTaskCell(cell, section: 0, row: row)
                
            }.disposed(by: disposeBag)*/
        
        
        
        
        
        
    }
    
    
    
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return TasksList.shared.uncompletedTasks.value.count
        } else {
            return TasksList.shared.completedTasks.value.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.Identifier, for: indexPath) as! TaskCell
        viewModel.configureTaskCell(cell, indexPath: indexPath)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            let task = TasksList.shared.sect.value[indexPath.section].items[indexPath.row]
            self.viewModel.editTask(task)
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            if indexPath.section == 0 {
                
            } else {
                
            }
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        })
        
        return [deleteAction,editAction]
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return UITableViewCell.EditingStyle.none
//    }
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
