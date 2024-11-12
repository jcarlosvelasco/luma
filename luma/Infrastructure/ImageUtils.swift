//
//  ImageUtils.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class ImageUtils {
    let context: CIContext
    
    init(context: CIContext) {
        self.context = context
    }
    
    func prepareImage(image: UIImage, width: Int, height: Int) -> CVPixelBuffer? {
        guard let scaledImage = image.resizedImage(to: CGSize(width: width, height: height)) else {
            return nil
        }
        
        guard let pixelBuffer = scaledImage.toCVPixelBuffer() else {
            return nil
        }
        
        return pixelBuffer
    }
    
    func pixelBufferToUIImage(_ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    func cropBlackBars(from processedImage: UIImage, originalImage: UIImage) -> UIImage? {
         let originalSize = originalImage.size
         let processedSize = processedImage.size

         // Calculate scale factor to get back to original aspect ratio
         let widthRatio = processedSize.width / originalSize.width
         let heightRatio = processedSize.height / originalSize.height
         let scaleFactor = min(widthRatio, heightRatio)

         // Calculate the size of the image without black bars
         let croppedWidth = originalSize.width * scaleFactor
         let croppedHeight = originalSize.height * scaleFactor

         // Calculate the cropping rectangle
         let x = (processedSize.width - croppedWidth) / 2
         let y = (processedSize.height - croppedHeight) / 2
         let croppingRect = CGRect(x: x, y: y, width: croppedWidth, height: croppedHeight)

         // Crop the image
         if let cgImage = processedImage.cgImage?.cropping(to: croppingRect) {
             return UIImage(cgImage: cgImage)
         }
         return nil
     }
}
