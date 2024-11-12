//
//  ApplyTweaks.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class ApplyTweaksInfrImpl: ApplyTweaksInfrType {
    let context: CIContext
    
    init(context: CIContext) {
        self.context = context
    }
    
    func applyTweaks(image: UIImage, tweaks: Tweaks) -> Result<UIImage, ApplyTweaksError> {
        guard let currentFilter = CIFilter(name: "CIColorControls") else {
            return .failure(.filterNotFound)
        }
        
        let beginImage = CIImage(image: image)

        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(tweaks.contrast, forKey: kCIInputContrastKey)
        currentFilter.setValue(tweaks.brighness, forKey: kCIInputBrightnessKey)
        currentFilter.setValue(tweaks.saturation, forKey: kCIInputSaturationKey)

        guard let outputImage = currentFilter.outputImage else {
            return .failure(.filterOutputError)
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return .failure(.cgImageCreationError)
        }
        
        return .success(UIImage(cgImage: cgImage))
    }
}
