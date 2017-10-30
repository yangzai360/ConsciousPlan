//
//  EKColorPickRow.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/3/30.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import Foundation
import Eureka
import UIKit

// MARK: Custom Cell
public class EKColorPickCell : Cell<UIColor>, CellType {
    @IBOutlet weak var colorView: UIView!
    open override func setup() {
        height = { 44 }
        super.setup()
    }
    open override func update() {
        super.update()
        colorView.backgroundColor = row.value
    }
    open override func didSelect() {
        super.didSelect()
        row.deselect()
        row.updateCell()
    }
}
// MARK: 简单的展示 Row
public final class EKColorNormalRow: Row<EKColorPickCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<EKColorPickCell>(nibName: "EKColorPickCell")
    }
}

// MARK: - 下面是内页面使用的 Cell

// MARK: Custom Cell
public class EKColorCheckCell : Cell<UIColor>, CellType {
    @IBOutlet weak var colorView: UIView!
    open override func update() {
        super.update()
        accessoryType = row.value != nil ? .checkmark : .none
        editingAccessoryType = accessoryType
        selectionStyle = .default
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        if row.isDisabled {
//            tintColor = UIColor(red: red, green: green, blue: blue, alpha: 0.3)
//            selectionStyle = .none
//        } else {
//            tintColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
//        }
        guard let row = self.row as? EKColorCheckRow else {
            return
        }
        colorView.backgroundColor = row.selectableValue
    }
    
    open override func setup() {
        super.setup()
        height = { 44 }
        row.title? = ""
        accessoryType =  .checkmark
        editingAccessoryType = accessoryType
    }
    
    open override func didSelect() {
        row.deselect()
        row.updateCell()
    }
}

// MARK: Selector Row.   里面左边显示颜色的供选择的 Row
public final class EKColorCheckRow: Row<EKColorCheckCell>, SelectableRowType {
    public var selectableValue: UIColor?
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<EKColorCheckCell>(nibName: "EKColorCheckCell")
    }
}
