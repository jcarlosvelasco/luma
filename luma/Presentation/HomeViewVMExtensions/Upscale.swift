//
//  Upscale.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation

extension HomeViewViewModel {
    func upscaleImage() async -> Void {
        DispatchQueue.main.async {
            self.loading = true
        }
        
        guard let inputImage = self.displayedImage else {
            showErrorAlert(msg: "No input image")
            return
        }
        
        let result = await self.upscaleImage.execute(image: inputImage)
        guard let outputImage = try? result.get() else {
            guard case .failure(let error) = result else {
                showErrorAlert(msg: "Unexpected error")
                return
            }
            handleError(error: error)
            return
        }
        
        DispatchQueue.main.async {
            self.imagePreview = outputImage
            self.loading = false
        }
    }
}
