//
//  ApplyNST.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

class ApplyNSTInfrImpl: ApplyNSTInfrType {
    let imageUtils: ImageUtils
    
    init(imageUtils: ImageUtils) {
        self.imageUtils = imageUtils
    }
    
    func applyFilters(image: UIImage, style: NSTStyle) async -> Result<UIImage, ApplyNSTError> {
        switch style {
        case .mosaic:
            let result = await setMosaicStyle(image: image)
            return result
        case .pontillism:
            let result = await setPointillismStyle(image: image)
            return result
        case .cartoon:
            let result = await setCartoonStyle(image: image)
            return result
        case .candy:
            let result = await setCandyStyle(image: image)
            return result
        case .rainPrincess:
            let result = await setRainPrincessStyle(image: image)
            return result
        case .udnie:
            let result = await setUdnieStyle(image: image)
            return result
        }
    }
    
    func setUdnieStyle(image: UIImage) async -> Result<UIImage, ApplyNSTError> {
        guard let model = try? Udnie(configuration: .init()) else {
            return .failure(.modelNotFound)
        }
        
        guard let pixelBuffer = imageUtils.prepareImage(image: image, width: 224, height: 224) else {
            return .failure(.resizingError)
        }
        
        let input = UdnieInput(input1: pixelBuffer)

        guard let output = try? await model.prediction(input: input) else {
            return .failure(.modelPredictionError)
        }
        
        guard let outputImage = imageUtils.pixelBufferToUIImage(output.output1) else {
            return .failure(.pBToUIImageError)
        }
        
        let result = imageUtils.cropBlackBars(from: outputImage, originalImage: image)
        
        guard let imageResult = result else {
            return .failure(.cropBlackBarsError)
        }
        
        return .success(imageResult)
    }
    
    func setCandyStyle(image: UIImage) async -> Result<UIImage, ApplyNSTError> {
        guard let model = try? Candy(configuration: .init()) else {
            return .failure(.modelNotFound)
        }
        
        guard let pixelBuffer = imageUtils.prepareImage(image: image, width: 224, height: 224) else {
            return .failure(.resizingError)
        }
    
        let input = CandyInput(input1: pixelBuffer)

        guard let output = try? await model.prediction(input: input) else {
            return .failure(.modelPredictionError)
        }
        
        guard let outputImage = imageUtils.pixelBufferToUIImage(output.output1) else {
            return .failure(.pBToUIImageError)
        }
        
        guard let result = imageUtils.cropBlackBars(from: outputImage, originalImage: image) else {
            return .failure(.cropBlackBarsError)
        }
    
        return .success(result)
    }
    
    func setMosaicStyle(image: UIImage) async -> Result<UIImage, ApplyNSTError> {
        guard let model = try? Mosaic(configuration: .init()) else {
            return .failure(.modelNotFound)
        }
        
        guard let pixelBuffer = imageUtils.prepareImage(image: image, width: 640, height: 960) else {
            return .failure(.pBToUIImageError)
        }
        
        let input = MosaicInput(input: pixelBuffer)

        guard let output = try? await model.prediction(input: input) else {
            return .failure(.modelPredictionError)
        }

        let activationOut = output.squeeze_out
        
        guard let outputImage = imageUtils.pixelBufferToUIImage(activationOut) else {
            return .failure(.pBToUIImageError)
        }
        
        guard let result = imageUtils.cropBlackBars(from: outputImage, originalImage: image) else {
            return .failure(.cropBlackBarsError)
        }
    
        return .success(result)
    }
    
    func setPointillismStyle(image: UIImage) async -> Result<UIImage, ApplyNSTError> {
        guard let model = try? Pointilism(configuration: .init()) else {
            return .failure(.modelNotFound)
        }
        
        guard let pixelBuffer = imageUtils.prepareImage(image: image, width: 224, height: 224) else {
            return .failure(.resizingError)
        }
        
        let input = PointilismInput(input1: pixelBuffer)

        guard let output = try? await model.prediction(input: input) else {
            return .failure(.modelPredictionError)
        }
        
        guard let outputImage = imageUtils.pixelBufferToUIImage(output.output1) else {
            return .failure(.pBToUIImageError)
        }
        
        guard let result = imageUtils.cropBlackBars(from: outputImage, originalImage: image) else {
            return .failure(.cropBlackBarsError)
        }
    
        return .success(result)
    }
    
    func setRainPrincessStyle(image: UIImage) async -> Result<UIImage, ApplyNSTError> {
        guard let model = try? RainPrincess(configuration: .init()) else {
            return .failure(.modelNotFound)
        }
        
        guard let pixelBuffer = imageUtils.prepareImage(image: image, width: 224, height: 224) else {
            return .failure(.resizingError)
        }
        
        let input = RainPrincessInput(input1: pixelBuffer)

        guard let output = try? await model.prediction(input: input) else {
            return .failure(.modelPredictionError)
        }
        
        guard let outputImage = imageUtils.pixelBufferToUIImage(output.output1) else {
            return .failure(.pBToUIImageError)
        }
        
        guard let result = imageUtils.cropBlackBars(from: outputImage, originalImage: image) else {
            return .failure(.cropBlackBarsError)
        }
        
        return .success(result)
    }
    
    func setCartoonStyle(image: UIImage) async -> Result<UIImage, ApplyNSTError> {
        guard let model = try? WhiteBoxCartoonization(configuration: .init()) else {
            return .failure(.modelNotFound)
        }
        
        guard let pixelBuffer = imageUtils.prepareImage(image: image, width: 1536, height: 1536) else {
            return .failure(.resizingError)
        }
        
        let input = WhiteBoxCartoonizationInput(Placeholder: pixelBuffer)

        guard let output = try? await model.prediction(input: input) else {
            return .failure(.modelPredictionError)
        }
        
        guard let outputImage = imageUtils.pixelBufferToUIImage(output.activation_out) else {
            return .failure(.pBToUIImageError)
        }
        
        guard let result = imageUtils.cropBlackBars(from: outputImage, originalImage: image) else {
            return .failure(.cropBlackBarsError)
        }
        
        return .success(result)
    }
}
