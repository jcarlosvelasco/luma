//
//  ApplyTweaksRepository.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class ApplyTweaksRepository: ApplyTweaksRepositoryType {
    let applyTweaks: ApplyTweaksInfrType
    let errorMapper: ImageDomainErrorMapper

    init(tweaks: ApplyTweaksInfrType, errorMapper: ImageDomainErrorMapper) {
        self.applyTweaks = tweaks
        self.errorMapper = errorMapper
    }
    
    func applyTweaks(image: UIImage, tweaks: Tweaks) -> Result<UIImage, ImageDomainError> {
        let result = applyTweaks.applyTweaks(image: image, tweaks: tweaks)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
}
