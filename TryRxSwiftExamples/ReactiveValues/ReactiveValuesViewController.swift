//
//  ReactiveValuesViewController.swift
//  TryRxSwiftExamples
//
//  Created by 平岡修 on 2021/03/19.
//

import UIKit
import RxSwift
import RxCocoa

class ReactiveValuesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        example()
        rxExample()
    }
    
    // MARK: - imperative code that is not desired behavior

    func example() {
        
        var a = 1       // 一度だけaに1が割り当てられます
        var b = 2       // 一度だけbに2が割り当てられます
        var c = "値が代入されていません"

        if a + b >= 0 {
            c = "\(a + b) は正の数です" // 一度だけcに値が割り当てられます
        }
        
        print("a = 1 の時のcの値：", c)
        
        a = 4
        b = 3
        
        print("a = 4 で b = 3 の時のcの値：", c)
    }
    
    // MARK: - Code that improved logic using RxSwift
    
    func rxExample() {
        
        let a = BehaviorRelay(value: 1)   // a = 1
        let b = BehaviorRelay(value: 2)   // b = 2

        // aとbを合計した最新の値（Combines latest values) をcに割り当て
        let c = Observable.combineLatest(a, b) { $0 + $1 }
            .filter { $0 >= 0 }               // もし 'a + b >= 0' がtrueなら、 `a + b` はmapオペレーターで処理されます
            .map { "\($0) は正の数です" }      // cに割り当てられた 'a + b' を文字列 "\(a + b) は正の数です"　に変換

        // a = 1 と b = 2　という初期値なので
        // 初め、cの値は "3 は正の数です"

        // cから値をsubscribeするというのは、'Observable'のcから値を引き出すという意味で
        // 'subscribe(onNext:)' は最新の値(next value)を引き出すということを意味し、値が変化する度に'subscribe(onNext:)'の処理が実行されます
        // この時点で、"3 は正の数です"という値を持っています
        c.subscribe(onNext: { print($0) }) // prints: "3 は正の数です"

        // じゃあ、今から `a`　の値を増やしてみましょう
        // acceptメソッドは受け取った値をsubscriberに渡します
        a.accept(4)                                   // prints: "6 は正の数です"
        // これで a + b の合計の最新の値は、 `4　＋　2`　で６になっています
        // `6 >= 0`なのでfilter処理を通過し, mapオペレーターによって "6 is positive"という文字列に変換されます
        // そして、その結果がcに割り当てらます
        // cの値が最新の値に変更されたので, `{ print($0) }` という処理が呼び出され、
        // "6 は正の数です" がログに出力されます

        // では、bの値を変更してみましょう
        b.accept(-8)                                 // 何も出力されません
        // a + b の合計の最新の値は、 `4 + (-8)`で `-4`になっています
        //  `>= 0` というfilter処理の条件に当てはまれない為、通過できず map処理が行われません。
        // map処理が行われないということは、cの値は"6 is positive"のままになります。
        // 最新の値に更新が無い為、最新の値を引き出すsubscribe（onNext:）処理も呼び出されません
        // よって `{ print($0) }` の処理が実行されない仕組みです
    }
}
