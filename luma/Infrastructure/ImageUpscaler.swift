//
//  ImageUpscaler.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class ImageUpscaler: ImageUpscalerInfrastructureType {
    let imageUtils: ImageUtils

    init(imageUtils: ImageUtils) {
        self.imageUtils = imageUtils
    }
    
    func upscaleImage(image: UIImage) async -> Result<UIImage, ImageUpscalerError> {
        guard let model = try? RealESRGAN512(configuration: .init()) else {
            return .failure(.modelNotFound)
        }
        
        let scaleResult = imageUtils.prepareImage(image: image, width: 512, height: 512)
        
        guard let pixelBuffer = scaleResult else {
            return .failure(.imageResizingError)
        }

        let input = RealESRGAN512Input(input: pixelBuffer)
        guard let output = try? await model.prediction(input: input) else {
            return .failure(.modelPredictionError)
        }
        
        guard let outputImage = imageUtils.pixelBufferToUIImage(output.activation_out) else {
            return .failure(.pBToUIImageConversionError)
        }
        
        let result = imageUtils.cropBlackBars(from: outputImage, originalImage: image)
        
        guard let imageResult = result else {
            return .failure(.cropBlackBarsError)
        }
        
        return .success(imageResult)
    }
}
