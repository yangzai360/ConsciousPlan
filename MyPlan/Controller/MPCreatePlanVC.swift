//
//  MPCreatePlanVC.swift
//  MyPlan
//
//  Created by jieyang on 17/3/26.
//  Copyright © 2017年 Sean.Jie. All rights reserved.
//

import UIKit
import Eureka
import CoreData

class MPCreatePlanVC : FormViewController, UsesCoreDataObjects {
    
// MARK: - Properties
    var managedObjectContext: NSManagedObjectContext?
    
    lazy var plan: MPPlan = {
//MARK: - 初始化 - 计划 对象
        return MPPlan.newPlan(context: self.managedObjectContext!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = plan.createDate == nil ? "创建计划" : "编辑计划"
        self.updateAppearance(tintColor: plan.tintColor as! UIColor)
        self.initializeForm()
    }

    func initializeForm() {
        form +++ self.formSection()
            <<< TextRow() {
                $0.title = "计划名称"
                $0.placeholder = "请输入计划名称"
                $0.value = self.plan.planName
                }.onChange{ row in
                    self.plan.planName = row.value
                }
        
        form +++ self.formSection()
            <<< PushRow<PlanType>("planType") {
                $0.title = "计划类型"
                let options = [PlanType.CountType, PlanType.ToDoType] //暂时关掉 定时任务
                $0.options = options
                $0.value = PlanType.allValues[Int(self.plan.planType)]
                $0.selectorTitle = "选择计划类型"
                }.onChange { row in
                    if row.value == nil {
                        row.value = PlanType.allValues[Int(self.plan.planType)]
                        return
                    }
                    let value = PlanType.allValues.index(of: row.value!)
                    self.plan.planType = Int32(value!)
                }
        
        form +++ self.formSection()
            <<< EKColorNormalRow("TintColor") {
                $0.title = "主题"
                $0.value = plan.tintColor as? UIColor
                $0.onCellSelection({ (cell, row) in
                    let colorPickerVC = EKColorPickerVC()
                    colorPickerVC.row = row
                    self.navigationController?.pushViewController(colorPickerVC, animated: true)
                }).onChange({ (row) in
                    if row.value == nil {
                        row.value = self.plan.tintColor as? UIColor
                        return
                    }
                    self.plan.tintColor = row.value
                    self.updateAppearance(tintColor: self.plan.tintColor as! UIColor)
                    row.updateCell()
                })
            }
        
        form +++ self.formSection()
            <<< SwitchRow("全天") {
            $0.title = $0.tag
            $0.value = self.plan.isAllDayTime
            }.onChange { [weak self] row in
                let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "开始时间")
                let endDate: DateTimeInlineRow! = self?.form.rowBy(tag: "结束时间")
                
                if row.value ?? false {
                    startDate.dateFormatter?.dateStyle = .medium
                    startDate.dateFormatter?.timeStyle = .none
                    endDate.dateFormatter?.dateStyle = .medium
                    endDate.dateFormatter?.timeStyle = .none
                } else {
                    startDate.dateFormatter?.dateStyle = .short
                    startDate.dateFormatter?.timeStyle = .short
                    endDate.dateFormatter?.dateStyle = .short
                    endDate.dateFormatter?.timeStyle = .short
                }
                startDate.updateCell()
                endDate.updateCell()
                startDate.inlineRow?.updateCell()
                endDate.inlineRow?.updateCell()
                
                self?.plan.isAllDayTime = row.value ?? false
            }
            
            <<< DateTimeInlineRow("开始时间") {
                $0.title = $0.tag
                $0.value = self.plan.beginTime as Date?
                $0.dateFormatter?.locale = Locale(identifier: "zh_CN")
                }.onChange { [weak self] row in
                    //更新结束时间的 Validation
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "结束时间")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                    self?.plan.beginTime = row.value as NSDate?;
                }.onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        cell.datePicker.locale = Locale(identifier: "zh_CN")
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "全天")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        } else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DateTimeInlineRow("结束时间") {
                $0.title = $0.tag
                $0.value = self.plan.endTime as Date?
                $0.dateFormatter?.locale = Locale(identifier: "zh_CN")
                }.onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "开始时间")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    } else {
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                    self?.plan.endTime = row.value as NSDate?;
                }.onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        cell.datePicker.locale = Locale(identifier: "zh_CN")
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "全天")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        } else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
        
        form +++ Section() { section in
            var header = HeaderFooterView(.class)
            header.height = {10}
            section.header = header
            
            var footer = HeaderFooterView(.class)
            footer.height = {0.1}
            section.footer = footer
            
            //todo 时候隐藏
            section.hidden = Condition.function(["planType"], { form in
                return Int(self.plan.planType) == 2
            })
            }

            //定量计划的时候出现
            <<< PushRow<PlanValueUnit>("unit") {
                $0.title = "计量单位"
                $0.hidden = Condition.function(["planType"], { form in
                    return Int(self.plan.planType) != 0
                })
                $0.options = PlanValueUnit.allValues
                $0.value = PlanValueUnit.allValues[Int(self.plan.unit)]
                $0.selectorTitle = "计量单位"
                }.onChange { row in
                    if row.value == nil {
                        row.value = PlanValueUnit.allValues[Int(self.plan.unit)]
                        return
                    }
                    let value = PlanValueUnit.allValues.index(of: row.value!)
                    self.plan.unit = Int32(value!)
            }
            <<< TextRow() {
                $0.title = "自定义单位"
                $0.placeholder = "请输入单位"
                $0.value = self.plan.customUnit
                
                $0.hidden = Condition.function(["planType", "unit"], { form in
                    return self.form.rowBy(tag: "unit")!.isHidden || (Int(self.plan.unit) != PlanValueUnit.allValues.count - 1)
                })
                
                }.onChange{ row in
                    self.plan.customUnit = row.value
            }
            
            //定时计划出现
            <<< PushRow<PlanTimeUnit>("timeUnit") {
                $0.title = "时间单位"
                $0.hidden = Condition.function(["planType"], { form in
                    return Int(self.plan.planType) != 1
                })
                $0.options = PlanTimeUnit.allValues
                $0.value = PlanTimeUnit.allValues[Int(self.plan.timeUnit)]
                $0.selectorTitle = "时间单位"
                }.onChange { row in
                    if row.value == nil {
                        row.value = PlanTimeUnit.allValues[Int(self.plan.timeUnit)]
                        return
                    }
                    let value = PlanTimeUnit.allValues.index(of: row.value!)
                    self.plan.timeUnit = Int32(value!)
            }
            
            <<< DecimalRow() {
                $0.title = "起始值"
                $0.placeholder = "计划的开始数值，默认为0"
                if self.plan.startValue != 0 {
                    $0.value = self.plan.startValue
                }
            }.onChange {
                self.plan.startValue = $0.value ?? 0
                self.plan.value = self.plan.startValue
            }
            
            <<< DecimalRow() {
                $0.title = "目标值"
                $0.placeholder = "计划目标"
                if self.plan.tergetValue != 0 {
                    $0.value = self.plan.tergetValue
                }
            }.onChange {
                    self.plan.tergetValue = $0.value ?? 0
            }
        
        form +++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete], header: "添加 ToDo 计划的子计划", footer: "") {
            $0.tag = "TodoSection"
            //ToDo 时候才展示
            $0.hidden = Condition.function(["planType"], { form in
                return Int(self.plan.planType) != 2 || self.plan.createDate != nil
            })
            $0.addButtonProvider = { section in
                return ButtonRow(){
                    $0.title = "添加子计划"
                }
            }
            $0.multivaluedRowToInsertAt = { index in
                return TextRow() {
                    $0.placeholder = "子计划名称"
                }
            }
        }
        
        form +++ self.formSection()
            <<< TextAreaRow() {
                $0.placeholder = "备注"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.value = self.plan.planRemarks
                }.onChange{
                    self.plan.planRemarks = $0.value ?? ""
                }
        
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        //组织数据
        //ToDo 的子项目加在 Plan 下面
        if plan.planType == 2 {
            for row in form.rows {
                guard row is TextRow, row.tag == "TodoSection", let subTodoName = row.baseValue as? String else { continue }
                let subTodo = SubTodo(context: managedObjectContext!)
                subTodo.createTime = NSDate()
                subTodo.name = subTodoName;
                plan.addToSubTodos(subTodo)
            }
            plan.startValue = 0
            plan.tergetValue = 1
        }
        //数据核实
        
        if let chechStr = plan.checkForCreatPlan() {
            alertWithMessage(msg: chechStr)
            return
        }
        //提醒确认
        
        //删掉无用数据
        
        plan.lastUpdate = NSDate()
        //判断是否是新创建的计划
        if( plan.createDate != nil ) {//已经有了创建时间，是旧计划
            managedObjectContext?.trySave()
            dismiss(animated:true , completion: nil)
        } else {
            plan.createDate = NSDate()
            managedObjectContext?.trySave()
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIBarButtonItem) {
        managedObjectContext!.rollback()
        dismiss(animated:true , completion: nil)
    }
    
    func formSection() -> Section {
        return Section() { section in
            var header = HeaderFooterView(.class)
            header.height = {10}
            section.header = header
            
            var footer = HeaderFooterView(.class)
            footer.height = {0.1}
            section.footer = footer
        }
    }
}
