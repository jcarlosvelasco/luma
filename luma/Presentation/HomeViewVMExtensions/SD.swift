//
//  SD.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

extension HomeViewViewModel {
    func submit() {
        guard case .startup = generation.state else { return }
        
        loading = true
        generation.state = .running(nil)
        
        Task {
            do {
                let result: GenerationResult
                
                if let displayedImage = self.displayedImage, let convertedImage = displayedImage.toCGImage(context: self.ciContext) {
                    result = try await generation.generate(startingImage: convertedImage)
                } else {
                    result = try await generation.generate()
                }
                
                DispatchQueue.main.async {
                    self.generation.state = .complete(self.generation.positivePrompt, result.image, result.lastSeed)
                    self.imagePreview = result.image.map { UIImage(cgImage: $0) }
                    self.loading = false
                }
            } catch {
                showErrorAlert(msg: "Error: \(error)")
                DispatchQueue.main.async {
                    self.generation.state = .failed(error)
                    self.loading = false
                }
            }
        }
    }
}
