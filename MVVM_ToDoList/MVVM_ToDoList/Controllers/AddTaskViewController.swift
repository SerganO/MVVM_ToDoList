//
//  AddTaskViewController.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/13/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

class AddTaskViewController: ViewController<AddTaskViewModel> {
    var textView = UITextView()
    var doneButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.rx.tap.bind {
            let task = self.viewModel.createTask(self.textView.text)
            self.viewModel.addTask(task)
            self.viewModel.services.sceneCoordinator.pop()
            }.disposed(by: viewModel.disposeBag)
        doneButton = UIBarButtonItem.init(customView: button)
        navigationItem.rightBarButtonItem = doneButton
        
        textView.resignFirstResponder()
        textView.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
    }
}
