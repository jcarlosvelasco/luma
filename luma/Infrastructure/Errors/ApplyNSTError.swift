//
//  ApplyNSTError.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation

enum ApplyNSTError: Error {
    case modelNotFound
    case resizingError
    case modelPredictionError
    case pBToUIImageError
    case cropBlackBarsError
}
