//
//  TaskCell.swift
//  MVVM_ToDoList
//
//  Created by Trainee on 6/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import SnapKit

class TaskCell: UITableViewCell {

    let taskTextLabel = UILabel(frame: .zero)
    let taskCompletedImageView = UIImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constructor()
    }
    
    func constructor() {
        
        let container = UIView(frame: .zero)
        contentView.addSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        container.addSubview(taskCompletedImageView)
        taskCompletedImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(5)
        }
        
        container.addSubview(taskTextLabel)
        taskTextLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTextLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        taskTextLabel.textAlignment = .center
        taskTextLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(taskCompletedImageView)
            make.leading.equalTo(taskCompletedImageView).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(taskTextLabel.font.lineHeight)
        }
        
        
        
    }


}
