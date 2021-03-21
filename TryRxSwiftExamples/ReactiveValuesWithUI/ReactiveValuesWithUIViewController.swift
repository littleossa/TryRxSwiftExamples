//
//  ReactiveValueWithUIViewController.swift
//  TryRxSwiftExamples
//
//  Created by 平岡修 on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ReactiveValuesWithUIViewController: UIViewController {
    
    @IBOutlet weak var aValueTextField: UITextField!
    @IBOutlet weak var bValueTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aValueTextField.becomeFirstResponder() // キーボードを開く
        reactiveValues()
    }
    
    func reactiveValues() {
        
        // combineLatestでReactive型に変更したtextFieldのtextを合計する
        Observable.combineLatest(aValueTextField.rx.text.orEmpty, bValueTextField.rx.text.orEmpty){ aValue, bValue -> Int in
            return (Int(aValue) ?? 0) + (Int(bValue) ?? 0)
        }
        // 入ってきた値(Int)をStringに変換
        .map{ "合計は、 \($0) です" }
        // UI(今回はresultLabel)に変更した値を割り当てる
        .bind(to: resultLabel.rx.text)
        // DisposeBagはまとめてObservableを破棄する為の仕組みでViewControllerが破棄されるときに自動で働きます
        .disposed(by: disposeBag)
    }
}
