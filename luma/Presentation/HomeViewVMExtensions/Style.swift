//
//  Style.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation

extension HomeViewViewModel {
    func setStyle(_ style: NSTStyle) async {
        guard let inputImage = displayedImage else {
            showErrorAlert(msg: "No displayed image")
            return
        }
                
        let result = await applyNST.execute(image: inputImage, style: style)
        guard let output = try? result.get() else {
            guard case .failure(let error) = result else {
                showErrorAlert(msg: "Unexpected error")
                return
            }
            handleError(error: error)
            return
        }
        
        DispatchQueue.main.async {
            self.imagePreview = output
        }
    }
}
