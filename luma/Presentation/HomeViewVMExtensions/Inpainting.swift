//
//  Inpainting.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import UIKit

extension HomeViewViewModel {
    func doInpainting() async {
        DispatchQueue.main.async {
            self.loading = true
        }
        let image = makeImageFromCanvasLines(lines: linesPreview)
        
        let result = await removeObject.execute(image: self.imagePreview ?? self.displayedImage!, mask: image)
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
            self.lines = []
            self.linesPreview = []
            self.loading = false
        }
    }
    
    private func makeImageFromCanvasLines(lines: [Line]) -> UIImage {
        let size = CGSize(width: displayedImageSize.width, height: displayedImageSize.height)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            let ctx = context.cgContext
            
            ctx.setFillColor(UIColor.black.cgColor)
            ctx.fill(CGRect(origin: .zero, size: size))
            
            for line in lines {
                ctx.setStrokeColor(CGColor(red: 255, green: 255, blue: 255, alpha: 1))
                ctx.setLineWidth(line.lineWidth)
                
                guard let firstPoint = line.points.first else { continue }
                ctx.beginPath()
                ctx.move(to: firstPoint)
                
                for point in line.points.dropFirst() {
                    ctx.addLine(to: point)
                }
                
                ctx.strokePath()
            }
        }
        
        return image
    }
}
