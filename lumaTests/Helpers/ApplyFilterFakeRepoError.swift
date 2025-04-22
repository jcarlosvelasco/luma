//
//  ApplyFilterFakeRepoError.swift
//  ImageApp2Tests
//
//  Created by Juan Carlos Velasco on 19/8/24.
//

import Foundation
@testable import luma
import UIKit

class ApplyFilterFakeRepoError: ApplyFilterRepositoryType {
    func applyFilter(image: UIImage, filter: FilterType) -> Result<UIImage, ImageDomainError> {
        return .failure(.modelError)
    }
}
