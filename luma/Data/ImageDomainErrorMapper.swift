//
//  ImageDomainErrorMapper.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation

class ImageDomainErrorMapper {
    func map(error: FilterError) -> ImageDomainError {
        switch error {
        case .filterNotFound:
            return .itemNotFound
        case .uiImagetoCIImageConversionError:
            return .conversionError
        case .filterOutputError:
            return .modelError
        case .cgImageCreationError:
            return .modelError
        case .cgImageToUIImageConversionError:
            return .conversionError
        }
    }
    
    func map(error: ApplyNSTError) -> ImageDomainError {
        switch error {
        case .modelNotFound:
            return .itemNotFound
        case .resizingError:
            return .conversionError
        case .modelPredictionError:
            return .modelError
        case .pBToUIImageError:
            return .conversionError
        case .cropBlackBarsError:
            return .conversionError
        }
    }
    
    func map(error: ImageUpscalerError) -> ImageDomainError {
        switch error {
        case .modelNotFound:
            return .itemNotFound
        case .modelPredictionError:
            return .modelError
        case .imageResizingError:
            return .conversionError
        case .pBToUIImageConversionError:
            return .conversionError
        case .cropBlackBarsError:
            return .conversionError
        }
    }
    
    func map(error: InpaintingError) -> ImageDomainError {
        switch error {
        case .modelNotFound:
            return .itemNotFound
        case .inputError:
            return .generic
        case .modelPredictionError:
            return .modelError
        case .pbToImageConversionError:
            return .conversionError
        case .cropBlackBarsError:
            return .conversionError
        case .addPaddingError:
            return .conversionError
        }
    }
    
    func map(error: ApplyTweaksError) -> ImageDomainError {
        switch error {
        case .filterNotFound:
            return .itemNotFound
        case .filterOutputError:
            return .modelError
        case .cgImageCreationError:
            return .conversionError
        }
    }
}
