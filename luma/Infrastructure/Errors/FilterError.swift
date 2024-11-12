//
//  FilterError.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation

enum FilterError: Error {
    case filterNotFound
    case uiImagetoCIImageConversionError
    case filterOutputError
    case cgImageCreationError
    case cgImageToUIImageConversionError
}
