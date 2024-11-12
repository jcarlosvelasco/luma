//
//  ApplyFilterType.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol ApplyFiltersType {
    func addFilter(image: UIImage, filter: FilterType) -> Result<UIImage, FilterError>
}
