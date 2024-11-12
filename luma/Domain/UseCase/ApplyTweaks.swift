//
//  ApplyTweaks.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol ApplyTweaksType {
    func execute(image: UIImage, tweaks: Tweaks) -> Result<UIImage, ImageDomainError>
}

class ApplyTweaks: ApplyTweaksType {
    let repo: ApplyTweaksRepositoryType
    
    init(repo: ApplyTweaksRepositoryType) {
        self.repo = repo
    }
    
    func execute(image: UIImage, tweaks: Tweaks) -> Result<UIImage, ImageDomainError> {
        let result = repo.applyTweaks(image: image, tweaks: tweaks)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        return .success(image)
    }
}

