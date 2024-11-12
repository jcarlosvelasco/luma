//
//  InpaintingError.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation

enum InpaintingError: Error {
    case modelNotFound
    case inputError
    case modelPredictionError
    case pbToImageConversionError
    case cropBlackBarsError
    case addPaddingError
}
