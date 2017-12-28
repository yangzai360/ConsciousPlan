//
//  MPTodoCell.swift
//  MyPlan
//
//  Created by jieyang on 2017/12/20.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit

protocol MPTodoCellDelegate: class {
    func didSelectTodoCell(sender: MPTodoCell)
}
class MPTodoCell: UITableViewCell {
    
    weak var delegate: MPTodoCellDelegate?

    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var nameCenterYCons: NSLayoutConstraint!
    @IBOutlet weak var deleteLineWidth: NSLayoutConstraint!
    @IBOutlet weak var deleteLineView: UIView!
    @IBOutlet weak var doneTimeLabel: UILabel!
    
    var isDone = false
    
    static var dateFormatter: DateFormatter = {
        let newDateFormatter = DateFormatter()
        newDateFormatter.locale     = Locale(identifier: "zh")
        newDateFormatter.dateStyle  = DateFormatter.Style.long
        newDateFormatter.dateFormat = newDateFormatter.dateFormat + " HH:mm"
        return newDateFormatter
    }()
    
    func conigureCell(withToDo todo: SubTodo) {
        isDone = todo.value
        name.text = todo.name ?? ""
        
        selectImageButton.setImage(UIImage.init(named: isDone ? "ic_selected" : "ic_select"), for: .normal)
        name.sizeToFit()
        deleteLineWidth.constant = name.frame.size.width + 6.0
        nameCenterYCons.constant = isDone ? -8 : 0
        doneTimeLabel.text = MPTodoCell.dateFormatter.string(for: todo.doneTime)
        doneTimeLabel.isHidden = !isDone
        deleteLineView.isHidden = !isDone
    }
    
    //MARK: - Target.
    
    @IBAction func selectBtnClicked(_ sender: Any) {
        print("sleect taptaptap")
        delegate?.didSelectTodoCell(sender: self)
    }
}


protocol MPTodoTagCellDelegate: class {
    func didClickTagButton()
}
class MPTodoTagCell: UITableViewCell {
    
    weak var delegate: MPTodoTagCellDelegate?
    @IBOutlet weak var tagButton: UIButton!
    
    func setTagColor(color: UIColor) {
        let rgbColours = color.cgColor.components
        let lightColor = UIColor(red: rgbColours![0]*0.7, green: rgbColours![1]*0.7, blue: rgbColours![2]*0.7, alpha: 1)
        tagButton?.backgroundColor = lightColor
    }
    
    @IBAction func tagButtonClicked(_ sender: Any) {
        delegate?.didClickTagButton()
    }
}
