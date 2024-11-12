//
//  CreateImage.swift
//  ImageApp2Tests
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation
import UIKit

class CreateImage {
    static func createImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        
        UIColor.lightGray.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        let mockImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return mockImage!
    }
}
