//
//  MPTodoCell.swift
//  MyPlan
//
//  Created by jieyang on 2017/12/20.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit

class MPTodoCell: UITableViewCell {
    
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var deleteLineWidth: NSLayoutConstraint!
    @IBOutlet weak var deleteLineView: UIView!
    
    
    var isDone = false {
        didSet {
            selectImageView.image = UIImage.init(named: isDone ? "ic_selected" : "ic_select")
        }
    }
    
    func conigureCell(withToDo todo: SubTodo) {
        isDone = todo.value
        name.text = todo.name ?? ""
        
        selectImageView.image = UIImage.init(named: isDone ? "ic_selected" : "ic_select")
        name.sizeToFit()
        deleteLineView.isHidden = !isDone
        deleteLineWidth.constant = name.frame.size.width + 6.0
    }
}

class MPTodoTagCell: UITableViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    
    func setTagColor(color: UIColor) {
        let rgbColours = color.cgColor.components
        let lightColor = UIColor(red: rgbColours![0]*0.7, green: rgbColours![1]*0.7, blue: rgbColours![2]*0.7, alpha: 1)
        tagLabel?.backgroundColor = lightColor
    }
}
