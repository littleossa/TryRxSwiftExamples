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
    @IBOutlet weak var plusOrMinusButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aValueTextField.becomeFirstResponder() // キーボードを開く
        reactiveValues()
    }
    
    func reactiveValues() {
        
        // プラスマイナスボタンの状態を監視する為に初期値に＋を割り当てたBehaivorRelayを作成
        let plusOrMinusState = BehaviorRelay(value: PlusOrMinus.plus)
        
        // 計算の合計値を監視する為に初期値に0を割り当ててBehaivorRelayを作成
        let totalNumber = BehaviorRelay(value: 0)
        
        // 結果を正の数ではない場合表示しないようにする為のObeservableを作成
        // 合計値が0以下の場合、trueが代入される
        let resultLabelValid = totalNumber
            .map { $0 <= 0 }
            .share(replay: 1)
        
        // プラスマイナスボタンの状態を監視し、値が変わったらplusOrMinusBUttonのimageにバインド
        plusOrMinusState.map { UIImage(systemName: $0.imageName) }
            .bind(to: plusOrMinusButton.rx.backgroundImage(for: .normal))
            .disposed(by: disposeBag)
        
        // 計算の合計値を監視し、値が変わったらString型に変換し、resultLabelのtextにバインド
        totalNumber
            .map { "合計は、 \($0) です" }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        // resultLabelValidのBool値を監視し、値が変わったらresultLabelのisHiddenにバインド
        resultLabelValid
            .bind(to: resultLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // combineLatestでReactive型に変更したtextFieldのtextを合計、
        // plusOrMinusStateの状態で合計値の計算方法をスイッチし、
        // totalNumberに計算結果をバインド
        Observable.combineLatest(aValueTextField.rx.text.orEmpty, bValueTextField.rx.text.orEmpty, plusOrMinusState){ aValue, bValue, state -> Int in
            switch state {
            case .plus:
                return (Int(aValue) ?? 0) + (Int(bValue) ?? 0)
            case .minus:
                return (Int(aValue) ?? 0) - (Int(bValue) ?? 0)
            }
        }
        .bind(to: totalNumber)
        .disposed(by: disposeBag)
        
        // plusOrMinusButtonがタップされたらplusOrMinusStateの値を変更する
        plusOrMinusButton.rx.tap
            .subscribe(onNext: { _ in
                
                switch plusOrMinusState.value {
                case .plus:
                    plusOrMinusState.accept(.minus)
                case .minus:
                    plusOrMinusState.accept(.plus)
                }
            })
            .disposed(by: disposeBag)
    }
}
