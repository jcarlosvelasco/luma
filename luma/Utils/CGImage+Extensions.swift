//
//  CGImage+Extensions.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import CoreGraphics
import UIKit

extension CGImage {
    static func fromData(_ imageData: Data) -> CGImage? {
        if let image = UIImage(data: imageData)?.cgImage {
            return image
        }
        return nil
    }
}

