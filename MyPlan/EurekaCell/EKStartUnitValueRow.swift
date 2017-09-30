//
//  EKStartUnitValueRow.swift
//  MyPlan
//
//  Created by Sean.Jie on 2017/4/7.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import Foundation
import UIKit
import Eureka

// MARK: Custom Cell
public class EKStartUnitValueCell : Cell<UIColor>, CellType {
    @IBOutlet weak var colorView: UIView!
    open override func setup() {
        height = { 44 }
        super.setup()
    }
    open override func update() {
        super.update()
//        colorView.backgroundColor = row.value
    }
    open override func didSelect() {
        super.didSelect()
//        row.deselect()
//        row.updateCell()
    }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class EKStartUnitValueRow: Row<EKStartUnitValueCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        // We set the cellProvider to load the .xib corresponding to our cell
        cellProvider = CellProvider<EKStartUnitValueCell>(nibName: "EKStartUnitValueCell")
    }
}
