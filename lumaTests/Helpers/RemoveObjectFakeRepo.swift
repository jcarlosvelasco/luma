//
//  RemoveObjectFakeRepo.swift
//  ImageApp2Tests
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation
@testable import luma
import UIKit

class RemoveObjectFakeRepo: RemoveObjectRepositoryType {
    func removeObject(image: UIImage, mask: UIImage) async -> Result<UIImage, ImageDomainError> {
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
