//
//  ApplyTweaksRepositoryType.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol ApplyTweaksRepositoryType {
    func applyTweaks(image: UIImage, tweaks: Tweaks) -> Result<UIImage, ImageDomainError>
}
