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

class TasksListViewController: ViewController<TasksListViewModel>, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView(frame: .zero,style: .grouped)
    var addButton = UIBarButtonItem()
    
    /*let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>(
     configureCell: { (_, tv, indexPath, element) in
     let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
     cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
     return cell
     },
     titleForHeaderInSection: { dataSource, sectionIndex in
     return dataSource[sectionIndex].model
     }
     )*/
    
    //let dataSources = SectionedViewDataSourceType<SectionModel<String,Double//
    
    //let dataSource = RxTableView
    
    
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
        }.disposed(by: viewModel.disposeBag)
        addButton = UIBarButtonItem.init(customView: button)
        navigationItem.rightBarButtonItem = addButton
        navigationItem.hidesBackButton = true
    }
    
    override func configure() {
        super.configure()
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.Identifier)
        //tableView.dataSource = self
        //tableView.delegate = self
        
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
        TasksList.shared.dataSource
            .bind(to: tableView.rx.items(cellIdentifier: TaskCell.Identifier, cellType: TaskCell.self)) {  row, element, cell in
                //cell.textLabel?.text = "\(element.text) \(row)"
                self.viewModel.taskViewModel.changeTask(element)
                self.viewModel.configureTaskCell(cell, section: 0, row: row)
                
            }.disposed(by: disposeBag)
        
        
        
        
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
        viewModel.configureTaskCell(cell, section: indexPath.section, row: indexPath.row)
        return cell
    }
    
    
}
