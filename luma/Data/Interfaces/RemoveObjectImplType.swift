//
//  RemoveObjectImplType.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

protocol RemoveObjectImplType {
    func doInpainting(image: UIImage, mask: UIImage) async -> Result<UIImage, InpaintingError>
}
