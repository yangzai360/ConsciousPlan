//
//  YZDigitalTextField.swift
//  MyPlan
//
//  Created by jieyang on 2017/12/10.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

extension UILabel {
    func setDouble(double: Double, count:String?) {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2 //最大小数位
        nf.positiveSuffix = count != nil ? " \(count!)" : ""
        let string = nf.string(from: NSNumber(value: double)) ?? ""
        self.text = string
    }
}

class YZDigitalTextField: UITextField {
    override var text: String? {
        didSet {
            if text == nil || text == "" {
                return
            }
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.maximumFractionDigits = 2 //最大小数位
            let number = NSNumber(value: NSString(string: self.text!).floatValue)
            super.text = nf.string(from: number)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return super.beginTracking(touch, with: event)
    }
}
