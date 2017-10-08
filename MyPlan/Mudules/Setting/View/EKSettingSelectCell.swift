//
//  EKSettingSelectRow.swift
//  MyPlan
//
//  Created by jieyang on 2017/10/7.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import Eureka

public class EKSettingSelectCell: Cell<String>, CellType {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public override func setup() {
        super.setup()
        height = { 44 }
    }
    public override func update() {
        super.update()
        titleLabel.text = row.value ?? ""
    }
    public override func didSelect() {
        row.deselect()
    }
}

public final class EKSettingSelectRow: Row<EKSettingSelectCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<EKSettingSelectCell>(nibName: "EKSettingSelectCell")
    }
}
