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
    
    var isDone = false {
        didSet {
            selectImageView.image = UIImage.init(named: isDone ? "ic_selected" : "ic_select")
        }
    }
}
