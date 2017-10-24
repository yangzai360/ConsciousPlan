//: Playground - noun: a place where people can play

import Foundation

//代码测试 orderedSet 的排序
let msets = NSOrderedSet(array: ["0", "1", "2", "3"])
msets.sortedArray(comparator: { (a1, a2) -> ComparisonResult in
    return ComparisonResult.orderedDescending
})

//let now = Date()
//let dateFormatter = DateFormatter()
//dateFormatter.locale = Locale(identifier: "zh")
//
//dateFormatter.dateStyle = DateFormatter.Style.full
//print(dateFormatter.string(from: now))
//
//dateFormatter.dateStyle = DateFormatter.Style.short
//print(dateFormatter.string(from: now))
//
//dateFormatter.dateStyle = DateFormatter.Style.long
//print(dateFormatter.string(from: now))
//
//dateFormatter.dateStyle = DateFormatter.Style.medium
//print(dateFormatter.string(from: now))
//
//for ot in 0...8 {
//    print(ot)
//    print( !(ot > 7 || ot<4 ) ? 1 : 0 )
//}

//let double = Double("1")
//print(double)


func test() -> String {
    
    
    print("A")
    return ""
}

func test2() -> String {
    print("1")
//    let _ = test()
    
    print("A")

    
    print("2")
    return ""
}

let _ = test2()
