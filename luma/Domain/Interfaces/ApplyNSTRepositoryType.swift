//
//  ApplyNSTRepositoryType.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol ApplyNSTRepositoryType {
    func applyNST(image: UIImage, style: NSTStyle) async -> Result<UIImage, ImageDomainError>
}
