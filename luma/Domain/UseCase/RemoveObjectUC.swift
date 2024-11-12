//
//  RemoveObject.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol RemoveObjectType {
    func execute(image: UIImage, mask: UIImage) async -> Result<UIImage, ImageDomainError>
}

class RemoveObjectUC: RemoveObjectType {
    let repo: RemoveObjectRepositoryType
    
    init(repo: RemoveObjectRepositoryType) {
        self.repo = repo
    }
    
    func execute(image: UIImage, mask: UIImage) async -> Result<UIImage, ImageDomainError> {
        let result = await repo.removeObject(image: image, mask: mask)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        return .success(image)
    }
}
