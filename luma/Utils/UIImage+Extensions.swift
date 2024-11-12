//
//  UIIMage+Extensions.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import UIKit

extension UIImage {
    func toCGImage(context: CIContext) -> CGImage? {
        let ciImage = CIImage(image: self)
        
        guard let safeCIImage = ciImage else {
            print("Can't convert from UIImage to CGImage")
            return nil
        }
        
        return context.createCGImage(safeCIImage, from: safeCIImage.extent) ?? nil
    }
    
    func resizedImage(to targetSize: CGSize) -> UIImage? {
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { _ in
            let x = (targetSize.width - scaledImageSize.width) / 2
            let y = (targetSize.height - scaledImageSize.height) / 2
            
            UIColor.black.setFill()
            UIRectFill(CGRect(origin: .zero, size: targetSize))
            
            self.draw(in: CGRect(x: x, y: y, width: scaledImageSize.width, height: scaledImageSize.height))
        }
        
        return image
    }
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }

        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)

            UIGraphicsPushContext(context!)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

            return pixelBuffer
        }

        return nil
    }
    
    func addingPaddingToSquare() -> UIImage? {
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        
        let sideLength = max(originalWidth, originalHeight)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: sideLength, height: sideLength), false, self.scale)
        
        UIColor.black.setFill()
        let rect = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
        UIRectFill(rect)
        
        let xOffset = (sideLength - originalWidth) / 2
        let yOffset = (sideLength - originalHeight) / 2
        self.draw(at: CGPoint(x: xOffset, y: yOffset))
        
        let paddedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return paddedImage
    }
}
