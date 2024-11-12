//
//  UpscaleImage.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol UpscaleImageType {
    func execute(image: UIImage) async -> Result<UIImage, ImageDomainError>
}

class UpscaleImage: UpscaleImageType {
    let repo: UpscaleImageRepositoryType
    
    init(repo: UpscaleImageRepositoryType) {
        self.repo = repo
    }
    
    func execute(image: UIImage) async -> Result<UIImage, ImageDomainError> {
        let result = await repo.upscaleImage(image: image)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        return .success(image)
    }
}
