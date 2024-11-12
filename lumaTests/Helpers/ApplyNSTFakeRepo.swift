//
//  ApplyNSTFakeRepo.swift
//  ImageApp2Tests
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation
@testable import ImageApp2
import UIKit

class ApplyNSTFakeRepo: ApplyNSTRepositoryType {
    func applyNST(image: UIImage, style: ImageApp2.NSTStyle) async -> Result<UIImage, ImageDomainError> {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        
        UIColor.lightGray.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        let mockImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let mockImage = mockImage {
            return .success(mockImage)
        }
        
        return .failure(.generic)
    }
}
