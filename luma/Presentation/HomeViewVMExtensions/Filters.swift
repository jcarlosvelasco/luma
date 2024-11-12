//
//  Filters.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation

extension HomeViewViewModel {
    func applyFilter(filter: FilterType) async {
        guard let inputImage = self.displayedImage else {
            showErrorAlert(msg: "No displayed image")
            return
        }
        
        let result = applyFilter.execute(image: inputImage, filter: filter)
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
