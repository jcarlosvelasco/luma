//
//  ApplyFilters.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import CoreImage
import UIKit

class ApplyFilters: ApplyFiltersInfrastructureType {
    let context: CIContext
    
    init(context: CIContext) {
        self.context = context
    }
    
    func addFilter(image: UIImage, filter: FilterType) -> Result<UIImage, FilterError> {
        guard let filter = CIFilter(name: filter.rawValue) else {
            return .failure(.filterNotFound)
        }
    
        guard let ciInput = CIImage(image: image) else {
            return .failure(.uiImagetoCIImageConversionError)
        }
        
        filter.setValue(ciInput, forKey: "inputImage")
        
        guard let ciOutput = filter.outputImage else {
            return .failure(.filterOutputError)
        }
        
        guard let cgImage = context.createCGImage(ciOutput, from: (ciOutput.extent)) else {
            return .failure(.cgImageCreationError)
        }

        return .success(UIImage(cgImage: cgImage))
    }
}
