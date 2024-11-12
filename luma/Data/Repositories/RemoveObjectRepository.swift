//
//  RemoveObjectRepository.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class RemoveObjectRepository: RemoveObjectRepositoryType {
    let removeObjectType: RemoveObjectImplType
    let errorMapper: ImageDomainErrorMapper
    
    init(removeObjectType: RemoveObjectImplType, errorMapper: ImageDomainErrorMapper) {
        self.removeObjectType = removeObjectType
        self.errorMapper = errorMapper
    }
    
    func removeObject(image: UIImage, mask: UIImage) async -> Result<UIImage, ImageDomainError> {
        let result = await removeObjectType.doInpainting(image: image, mask: mask)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
}
