//
//  SplashViewController.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: ViewController<SplashViewModel> {
    let Label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        Label.textAlignment = .center
        Label.text = "To Do List"
        
        view.addSubview(Label)
        Label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
