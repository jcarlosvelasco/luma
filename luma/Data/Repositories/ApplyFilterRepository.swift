//
//  ApplyFilterRepository.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class ApplyFilterRepository: ApplyFilterRepositoryType {
    let applyFilter: ApplyFiltersType
    let errorMapper: ImageDomainErrorMapper
    
    init(filter: ApplyFiltersType, errorMapper: ImageDomainErrorMapper) {
        self.applyFilter = filter
        self.errorMapper = errorMapper
    }
    
    func applyFilter(image: UIImage, filter: FilterType) -> Result<UIImage, ImageDomainError> {
        let result = applyFilter.addFilter(image: image, filter: filter)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
}


