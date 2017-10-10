//
//  UIViewControlelr+MPAppearance.swift
//  MyPlan
//
//  Created by jieyang on 17/4/2.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func defaultTintColor() -> UIColor {
        return UIColor.init(red: 50/255, green: 191/255, blue: 254/255, alpha: 1.0)  // DayOne Blue
    }
    
    func updateAppearance(tintColor : UIColor) {
        let rgbColours = tintColor.cgColor.components
        let yValue = 0.299 * rgbColours![0] + 0.587 * rgbColours![1] + 0.114 * rgbColours![2]
        let fontColor = yValue > 0.8 ? UIColor.black : UIColor.white
        
        let navController = self.navigationController!
        navController.navigationBar.barTintColor = tintColor
        navController.navigationBar.tintColor = fontColor
        let attr: [String : Any]! = [NSForegroundColorAttributeName: fontColor]
        navController.navigationBar.titleTextAttributes = attr
    }
    
    func alertWithMessage(msg: String) {
        let alertViewController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true, completion: nil)
    }
}
