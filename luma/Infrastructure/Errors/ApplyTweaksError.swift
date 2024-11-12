//
//  ApplyTweaksError.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation

enum ApplyTweaksError: Error {
    case filterNotFound
    case filterOutputError
    case cgImageCreationError
}
