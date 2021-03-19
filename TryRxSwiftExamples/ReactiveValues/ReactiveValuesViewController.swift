//
//  ReactiveValuesViewController.swift
//  TryRxSwiftExamples
//
//  Created by 平岡修 on 2021/03/19.
//

import UIKit

class ReactiveValuesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        example()
    }
    

    func example() {
        
        var a = 1       // this will only assign the value `1` to `a` once
        var b = 2       // this will only assign the value `2` to `b` once
        var c = "値が代入されていません"

        if a + b >= 0 {
            c = "\(a + b) is positive" // this will only assign the value to `c` once
        }
        
        print("a = 1 の時のcの値：", c)
        
        a = 4
        
        print("a = 4 の時のcの値：", c)
    }
}
