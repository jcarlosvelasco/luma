//
//  ApplyFilter.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol ApplyFilterType {
    func execute(image: UIImage, filter: FilterType) -> Result<UIImage, ImageDomainError>
}

class ApplyFilter: ApplyFilterType {
    let repo: ApplyFilterRepositoryType
    
    init(repo: ApplyFilterRepositoryType) {
        self.repo = repo
    }
    
    func execute(image: UIImage, filter: FilterType) -> Result<UIImage, ImageDomainError> {
        let result = repo.applyFilter(image: image, filter: filter)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        return .success(image)
    }
}
