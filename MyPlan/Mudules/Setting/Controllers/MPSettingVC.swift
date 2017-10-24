//
//  MPSettingVC.swift
//  MyPlan
//
//  Created by jieyang on 17/3/29.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import Eureka
import MessageUI

class MPSettingVC : FormViewController{
    
    @IBAction func doneItemBtnClicked(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initializeForm()
    }
    
    func initializeForm() {
        
        form +++ Section () { section in
            let header = HeaderFooterView<UIView>(.callback({ return UIView(frame: CGRect()) }))
            section.header = header
        }

        form +++ Section () { section in
            var header = HeaderFooterView<UIView>(.callback({
                let view = Bundle.main.loadNibNamed("MPSettingHeaderView", owner: nil, options: nil)?.first! as! UIView
                return view
            }))
            header.height = {160.0}
            section.header = header
            }
            
            <<< EKSettingSelectRow("技术支持") {
//                $0.title = "计划名称"
                $0.value = $0.tag
                }.onChange{ row in
                }.onCellSelection({ [weak self] (cell, row) in
                    self?.sendMail()
                })
        
        form +++ Section("")
            <<< ButtonRow("推荐给朋友") {
                $0.title = $0.tag
            }
            .onCellSelection { [weak self] (cell, row) in
//            self?.sendMail()
        }
    }
    
    //MARK: 发送邮件
    func sendMail() {
        guard MFMailComposeViewController.canSendMail() else {
            print("本设备并不支持发送邮件哦~")
            return
        }
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setSubject("自觉计划用户问题反馈：")
        mailVC.setToRecipients(["consciousplanhelp@icloud.com"])
        mailVC.setMessageBody("在使用中遇到的问题如下：\n", isHTML: false)
        present(mailVC, animated: true, completion: nil)
    }
}

// 发送邮件 ViewController Delegate
extension MPSettingVC : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        switch result {
        case .sent:
            print("sented")
        case .cancelled:
            print("cancelled")
        case .saved:
            print("saved")
        case .failed:
            print("failed")
        }
    }
}
