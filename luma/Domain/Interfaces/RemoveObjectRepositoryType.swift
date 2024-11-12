//
//  RemoveObjectRepositoryType.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol RemoveObjectRepositoryType {
    func removeObject(image: UIImage, mask: UIImage) async -> Result<UIImage, ImageDomainError>
}
