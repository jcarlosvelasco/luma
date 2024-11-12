//
//  RemoveObject.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class RemoveObject: RemoveObjectImplType {
    let imageUtils: ImageUtils
    
    init(imageUtils: ImageUtils) {
        self.imageUtils = imageUtils
    }
    
    func doInpainting(image: UIImage, mask: UIImage) async -> Result<UIImage, InpaintingError> {
        guard let model = try? LaMa(configuration: .init()) else {
            return .failure(.modelNotFound)
        }
        
        guard let squaredImage = image.addingPaddingToSquare(), let squaredMask = mask.addingPaddingToSquare() else {
            return .failure(.addPaddingError)
        }
        
        guard let input = try? LaMaInput(imageWith: squaredImage.cgImage!, maskWith: squaredMask.cgImage!) else {
            return .failure(.inputError)
        }
        
        guard let output = try? await model.prediction(input: input) else {
            return .failure(.modelPredictionError)
        }
        
        guard let imageOutput = imageUtils.pixelBufferToUIImage(output.output) else {
            return .failure(.pbToImageConversionError)
        }
        
        guard let result = imageUtils.cropBlackBars(from: imageOutput, originalImage: image) else {
            return .failure(.cropBlackBarsError)
        }
        
        return .success(result)
    }
}
