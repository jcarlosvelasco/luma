//
//  ImageUpscalerType.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol ImageUpscalerInfrastructureType {
    func upscaleImage(image: UIImage) async -> Result<UIImage, ImageUpscalerError>
}
