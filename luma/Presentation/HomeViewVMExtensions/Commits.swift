//
//  Commits.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit
import BrightroomEngine

extension HomeViewViewModel {
    func createImageCommit(image: UIImage) async {
        DispatchQueue.main.async {
            self.imageCommits.append(image)
            self.commitIndex = self.imageCommits.count - 1
            self.displayedImage = image
            self.imageProvider = ImageProvider(image: image)
            self.editingStack = EditingStack(imageProvider: self.imageProvider!)
        }
    }
    
    func setPreviousImageCommit()  {
        guard let index = self.commitIndex else {
            showErrorAlert(msg: "No index")
            return
        }
        
        if (index > 0) {
            let newIndex = index - 1
            self.displayedImage = self.imageCommits[newIndex]
            self.commitIndex = newIndex
        }
    }
    
    func setNextImageCommit() {
        guard let index = self.commitIndex else {
            showErrorAlert(msg: "No index")
            return
        }
        
        if (index < self.imageCommits.count - 1) {
            let newIndex = index + 1
            self.displayedImage = self.imageCommits[newIndex]
            self.commitIndex = newIndex
        }
    }
}
