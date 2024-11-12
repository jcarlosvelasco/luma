//
//  Error.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import Foundation

extension HomeViewViewModel {
    func handleError(error: ImageDomainError) {
        switch error {
            case .conversionError:
                self.errorMsg = "Conversion error"
            
            case .itemNotFound:
                self.errorMsg = "Item not found"
            
            case .generic:
                self.errorMsg = "Unexpected error"
            
            case .modelError:
             
            self.errorMsg = "Model error"
        }
        DispatchQueue.main.async {
            self.showErrorAlert = true
        }
    }
    
    func showErrorAlert(msg: String) {
        self.errorMsg = msg
        DispatchQueue.main.async {
            self.showErrorAlert = true
        }
    }
}
