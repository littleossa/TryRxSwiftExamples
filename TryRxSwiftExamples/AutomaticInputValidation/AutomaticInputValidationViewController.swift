//
//  AutomaticInputValidationViewController.swift
//  TryRxSwiftExamples
//
//  Created by 平岡修 on 2021/03/22.
//

import UIKit
import RxSwift
import RxCocoa

class AutomaticInputValidationViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.becomeFirstResponder() // キーボードを出す
        automaticInputValidation()
    }
    

    enum Availability {
        case available(message: String)
        case taken(message: String)
        case invalid(message: String)
        case pending(message: String)

        var message: String {
            switch self {
            case .available(let message),
                 .taken(let message),
                 .invalid(let message),
                 .pending(let message):

                 return message
            }
        }
    }
    
    func automaticInputValidation() {
        
        // bind UI control values directly
        // use username from `usernameOutlet` as username values source
        self.usernameTextField.rx.text
            .map { username -> Observable<Availability> in

                // synchronous validation, nothing special here
                guard let username = username, !username.isEmpty else {
                    // Convenience for constructing synchronous result.
                    // In case there is mixed synchronous and asynchronous code inside the same
                    // method, this will construct an async result that is resolved immediately.
                    return Observable.just(.invalid(message: "Username can't be empty."))
                }

                // ...

                // User interfaces should probably show some state while async operations
                // are executing.
                let loadingValue = Availability.pending(message: "Checking availability ...")

                // This will fire a server call to check if the username already exists.
                // Its type is `Observable<Bool>`
                return API.usernameAvailable(username)
                  .map { available in
                      if available {
                          return .available(message: "Username available")
                      }
                      else {
                          return .taken(message: "Username already taken")
                      }
                  }
                  // use `loadingValue` until server responds
                  .startWith(loadingValue)
            }
        // Since we now have `Observable<Observable<Availability>>`
        // we need to somehow return to a simple `Observable<Availability>`.
        // We could use the `concat` operator from the second example, but we really
        // want to cancel pending asynchronous operations if a new username is provided.
        // That's what `switchLatest` does.
            .switchLatest()
        // Now we need to bind that to the user interface somehow.
        // Good old `subscribe(onNext:)` can do that.
        // That's the end of `Observable` chain.
            .subscribe(onNext: { [weak self] validity in
                self?.validationLabel.textColor = validationColor(validity)
                self?.validationLabel.text = validity.message
            })
        // This will produce a `Disposable` object that can unbind everything and cancel
        // pending async operations.
        // Instead of doing it manually, which is tedious,
        // let's dispose everything automagically upon view controller dealloc.
            .disposed(by: disposeBag)
    }
}
