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
        if row.isDisabled {
            tintColor = UIColor(red: red, green: green, blue: blue, alpha: 0.3)
            selectionStyle = .none
        }
        else {
            tintColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
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

// MARK: Normal Row.
public final class EKColorPickRow: Row<EKColorPickCell>, RowType {   // Warning: 应该是在这里添加 OptionsProviderRow 协议
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<EKColorPickCell>(nibName: "EKColorPickCell")
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

// MARK: SelectorViewController:
// a subclass of _SelectorViewController with custom row type as generic parameter
//open class EKColorSelectorViewController : _SelectorViewController<EKColorCheckRow, EKColorPickRow>  {
//}
//open class EKColorSelectorViewController: _SelectorViewController<EKColorCheckRow, EKColorPickRow> {
//}

// MARK: 
// A subclass of SelectorRow with this controller as its generic parameter.
// Types hierarchy should be basically the same as for PushRow just with your custom selector controller in place.
//open class _EKColorPushSelectRow<Cell: CellType>: SelectorRow<Cell, EKColorSelectorViewController> where Cell: BaseCell, Cell.Value == UIColor {
//    public required init(tag: String?) {
//        super.init(tag: tag)
//        presentationMode = .show(controllerProvider: ControllerProvider.callback { return EKColorSelectorViewController(){ _ in } }, onDismiss: { vc in
//            let _ = vc.navigationController?.popViewController(animated: true) })
//    }
//}

open class _EKColorPushSelectRow<Cell: CellType>: SelectorRow<Cell> where Cell: BaseCell, Cell.Value == UIColor {
    public required init(tag: String?) {
        super.init(tag: tag)
//        presentationMode = .show(controllerProvider: ControllerProvider.callback { return EKColorSelectorViewController(){ _ in } }, onDismiss: { vc in
        presentationMode = .show(controllerProvider: ControllerProvider.callback { return SelectorViewController(){ _ in } }, onDismiss: { vc in
            let _ = vc.navigationController?.popViewController(animated: true) })
    }
}

public final class EKColorPushSelectRow : _EKColorPushSelectRow<EKColorPickCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<EKColorPickCell>(nibName: "EKColorPickCell")
    }
}
