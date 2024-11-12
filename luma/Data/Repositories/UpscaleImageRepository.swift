//
//  UpscaleImageRepository.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class ImageUpscaleRepository: UpscaleImageRepositoryType {
    let imageUpscalerModel: ImageUpscalerType
    let mapper: ImageDomainErrorMapper
    
    init(imageUpscalerModel: ImageUpscalerType, errorMapper: ImageDomainErrorMapper) {
        self.imageUpscalerModel = imageUpscalerModel
        self.mapper = errorMapper
    }
    
    func upscaleImage(image: UIImage) async -> Result<UIImage, ImageDomainError> {
        let result = await imageUpscalerModel.upscaleImage(image: image)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(mapper.map(error: error))
        }
        return .success(image)
    }
}
