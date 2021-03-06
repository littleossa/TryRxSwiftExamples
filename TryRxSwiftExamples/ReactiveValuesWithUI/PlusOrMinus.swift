//
//  PlusOrMinus.swift
//  TryRxSwiftExamples
//
//  Created by 平岡修 on 2021/03/22.
//

import Foundation

enum PlusOrMinus {
    case plus
    case minus
    
    var imageName: String {
                
        switch self {
        case .plus:
            return "plus.circle"
        case .minus:
            return "minus.circle"
        }
    }
}
