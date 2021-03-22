//
//  ReactiveValueWithUIViewController.swift
//  TryRxSwiftExamples
//
//  Created by 平岡修 on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa

enum PlusOrMinus {
    case plus
    case minus
    
    var imageName: String {
        
        let imageName: String
        
        switch self {
        case .plus:
            imageName = "plus.circle"
        case .minus:
            imageName = "minus.circle"
        }
        return imageName
    }
}

class ReactiveValuesWithUIViewController: UIViewController {
    
    @IBOutlet weak var aValueTextField: UITextField!
    @IBOutlet weak var bValueTextField: UITextField!
    @IBOutlet weak var plusOrMinusButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var theimage: UIImageView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aValueTextField.becomeFirstResponder() // キーボードを開く
        reactiveValues()
    }
    
    func reactiveValues() {
        
        let plusOrMinusState = BehaviorRelay(value: PlusOrMinus.plus)
        let totalNumber = BehaviorRelay(value: 0)
        
        let resultLabelValid = totalNumber
            .map { $0 < 0 }
            .share(replay: 1)
        
        plusOrMinusState.map { UIImage(systemName: $0.imageName) }
            .bind(to: plusOrMinusButton.rx.backgroundImage(for: .normal))
            .disposed(by: disposeBag)
        
        totalNumber
            .map { "合計は、 \($0) です" }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        resultLabelValid
            .bind(to: resultLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // combineLatestでReactive型に変更したtextFieldのtextを合計する
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
