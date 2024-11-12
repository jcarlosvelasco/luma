//
//  ApplyNSTRepository.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class ApplyNSTRepository: ApplyNSTRepositoryType {
    let applyNST: ApplyNSTInfrType
    let errorMapper: ImageDomainErrorMapper
    
    init(applyNST: ApplyNSTInfrType, errorMapper: ImageDomainErrorMapper) {
        self.applyNST = applyNST
        self.errorMapper = errorMapper
    }
    
    func applyNST(image: UIImage, style: NSTStyle) async -> Result<UIImage, ImageDomainError> {
        let result = await applyNST.applyFilters(image: image, style: style)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
}
