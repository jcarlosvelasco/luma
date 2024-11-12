//
//  ImageUpscalerError.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation

enum ImageUpscalerError: Error {
    case modelNotFound
    case modelPredictionError
    case imageResizingError
    case pBToUIImageConversionError
    case cropBlackBarsError
}
