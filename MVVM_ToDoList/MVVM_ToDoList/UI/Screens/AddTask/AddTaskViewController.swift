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
import UserNotifications

class AddTaskViewController: ViewController<AddTaskViewModel> {
    var textView = UITextView()
    var doneButton = UIBarButtonItem()
    var shouldRemindSwitch = UISwitch()
    var dueDateLabel = UILabel()
    var dateLabel = UILabel()
    var setDateButton = UIButton()
    var remindContainer = UIView()
    var remindLabel = UILabel()
    var separatorView = UIView()
    
    var dueDate = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateStyle = .none
        formatter.timeStyle = .long
        formatter.dateFormat = "EEEEEEEE"
        formatter.dateFormat = "MMM d hh:mm"
        
       
        viewModel.services.date.setDate(dueDate)
        
        navigationItem.title = "ADD"
        
        remindLabel.text = "Remind"
        remindLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        remindContainer.addSubview(remindLabel)
        remindLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
        }
        
        remindContainer.addSubview(shouldRemindSwitch)
        shouldRemindSwitch.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(remindLabel)
        }
        
        dateLabel.text = "Due Date: "
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        remindContainer.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(remindLabel.snp.bottom).offset(15)
        }
        
        updateDueDateLabel()
        remindContainer.addSubview(dueDateLabel)
        dueDateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
            make.centerY.equalTo(dateLabel)
        }
        
        setDateButton.setTitle("SET", for: .normal)
        setDateButton.setTitleColor(.black, for: .normal)
        setDateButton.setTitleColor(.gray, for: .highlighted)
        remindContainer.addSubview(setDateButton)
        setDateButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.greaterThanOrEqualTo(dueDateLabel.snp.trailing).offset(5)
        }
        setDateButton.rx.tap.bind {
            self.viewModel.services.sceneCoordinator.transition(to: Scene.date(DateViewModel(services: self.viewModel.services)), type: .push, animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.services.date.LastDate.asObservable().do(onNext: { (date) in
            self.dueDate = date
            self.updateDueDateLabel()
        }).subscribe().disposed(by: viewModel.disposeBag)
    
        
        
        remindContainer.backgroundColor = .white
        view.addSubview(remindContainer)
        remindContainer.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.height.equalTo(40)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        separatorView.backgroundColor = UIColor.gray
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.top.equalTo(remindContainer.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1 / UIScreen.main.scale)
        }
        
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        let done = UIButton()
        done.setTitle("Done", for: .normal)
        done.setTitleColor(.black, for: .normal)
        done.setTitleColor(.gray, for: .highlighted)
        done.rx.tap.bind {
                self.doneButtonTap()
            }.disposed(by: viewModel.disposeBag)
        doneButton = UIBarButtonItem.init(customView: done)
        navigationItem.rightBarButtonItem = doneButton
        
        shouldRemindSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(shouldRemindSwitch.rx.value)
            .subscribe(onNext: { (isOn) in
                self.switchTap(isOn: isOn)
            }).disposed(by: viewModel.disposeBag)
        
    
        if let editItem = viewModel.taskForEdit {
            textView.text = editItem.text
            if let notDate = editItem.notificationDate {
                shouldRemindSwitch.isOn = true
                dueDate = notDate
                updateDueDateLabel()
                self.remindContainer.snp.updateConstraints({ (update) in
                    update.height.equalTo(75)
                })
            }
            navigationItem.title = "EDIT"
        }
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    func doneButtonTap() {
        guard textView.text != "" else {
            let alert = UIAlertController(title: "Empty Task", message: "Please write anothing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let editItem = viewModel.taskForEdit {
            editItem.text = textView.text
            if shouldRemindSwitch.isOn {
                editItem.notificationDate = dueDate
            } else {
                editItem.notificationDate = nil
            }
            viewModel.editTask(editItem)
            viewModel.services.sceneCoordinator.pop()
        } else {
            let task = viewModel.createTask(textView.text)
            if shouldRemindSwitch.isOn {
                task.notificationDate = dueDate
            }
            viewModel.addTask(task)
            viewModel.services.sceneCoordinator.pop()
        }
    }
    
    func switchTap(isOn: Bool) {
        if isOn {
            viewModel.services.notification.allowNotification()
            remindContainer.snp.updateConstraints({ (update) in
                update.height.equalTo(75)
            })
        } else {
            remindContainer.snp.updateConstraints({ (update) in
                update.height.equalTo(40)
            })
        }
    }
    
    func updateDueDateLabel() {
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    
}
