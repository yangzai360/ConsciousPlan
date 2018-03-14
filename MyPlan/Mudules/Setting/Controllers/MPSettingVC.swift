//
//  MPSettingVC.swift
//  MyPlan
//
//  Created by jieyang on 17/3/29.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import Eureka
import MessageUI
import StoreKit

class MPSettingVC : FormViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
        
        updateAppearance(tintColor: self.defaultTintColor())
    }
    
    func initializeForm() {

        form +++ Section () { section in
            var header = HeaderFooterView<UIView>(.callback({
                let view = Bundle.main.loadNibNamed("MPSettingHeaderView", owner: nil, options: nil)?.first! as! UIView
                return view
            }))
            header.height = { 180.0 }
            section.header = header
            }
        
            <<< EKSettingSelectRow("当前版本") {
                $0.cell.titleLabel.text = $0.tag
                $0.value = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String // 动态获取Info里面的版本号
                $0.cell.accessoryType = .none
                $0.cell.selectionStyle = .none
                }
        
        form +++ Section()
            
            <<< EKSettingSelectRow("意见反馈") {
                $0.cell.titleLabel.text = $0.tag
                $0.value = ""
                }.onChange{ row in
                }.onCellSelection({ [weak self] (cell, row) in
                    self?.sendMail()
                })
        
            <<< EKSettingSelectRow("五星好评") {
                $0.cell.titleLabel.text = $0.tag
                $0.value = ""
                }.onChange{ row in
                }.onCellSelection({ (cell, row) in
                    SKStoreReviewController.requestReview()
                })
        
        form +++ Section() { section in
            let footer = HeaderFooterView(title: "使用自觉计划，记录追踪你的每一个计划，愿你的每一天过得充实有意义！\n\n@扬仔360")
            section.footer = footer
            }
            <<< ButtonRow("推荐给朋友") {
                $0.title = $0.tag
            }
            .onCellSelection { [weak self] (cell, row) in
                self?.activityShare()
        }
    }
    
    @IBAction func doneItemBtnClicked(_ sender: UIBarButtonItem) {
    }
    
    //MARK: 分享
    func activityShare() {
        let textToShare = "我在使用「自觉计划」App，一款计划管理软件，帮你记录追踪计划进度，愿你的每一天过得充实有意义！"
        let imageToShare = UIImage.init(named: "appLogo") as Any
        let urlToShare = "https://itunes.apple.com/us/app/自觉计划/id1358959588?l=zh&ls=1&mt=8"
        let activityItems = [textToShare, imageToShare, urlToShare] as [Any]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
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
        mailVC.setMessageBody("在使用中遇到的问题 & 优化建议如下：\n", isHTML: false)
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
