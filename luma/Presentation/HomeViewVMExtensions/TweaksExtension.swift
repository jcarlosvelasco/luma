//
//  Tweaks.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation

extension HomeViewViewModel {
    func applyTweaks() async {
        guard let index = commitIndex else {
            showErrorAlert(msg: "No index")
            return
        }
        
        let image = imageCommits[index]
        
        let tweaksObject = Tweaks(contrast: self.contrast, brighness: self.brightness, saturation: self.saturation)
        
        let result = self.applyTweaks.execute(image: image, tweaks: tweaksObject)
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
    
    func resetTweaks() {
        self.contrast = 1.0
        self.saturation = 1.0
        self.brightness = 0.0
    }
}
