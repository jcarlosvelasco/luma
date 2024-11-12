//
//  ApplyNST.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol ApplyNSTType {
    func execute(image: UIImage, style: NSTStyle) async -> Result<UIImage, ImageDomainError>
}

class ApplyNST: ApplyNSTType {
    let repo: ApplyNSTRepositoryType
    
    init(repo: ApplyNSTRepositoryType) {
        self.repo = repo
    }
    
    func execute(image: UIImage, style: NSTStyle) async -> Result<UIImage, ImageDomainError> {
        let result = await repo.applyNST(image: image, style: style)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        return .success(image)
    }
}
