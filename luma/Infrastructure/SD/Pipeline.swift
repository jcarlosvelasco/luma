//
//  Pipeline.swift
//  Diffusion
//
//  Created by Pedro Cuenca on December 2022.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//

import Foundation
import CoreML
import Combine

import StableDiffusion

struct StableDiffusionProgress {
    var progress: StableDiffusionPipeline.Progress

    var step: Int { progress.step }
    var stepCount: Int { progress.stepCount }

    var currentImages: [CGImage?]

    init(progress: StableDiffusionPipeline.Progress, previewIndices: [Bool]) {
        self.progress = progress
        self.currentImages = [nil]

        // Since currentImages is a computed property, only access the preview image if necessary
        if progress.step < previewIndices.count, previewIndices[progress.step] {
            self.currentImages = progress.currentImages
        }
    }
}

struct GenerationResult {
    var image: CGImage?
    var lastSeed: UInt32
    var userCanceled: Bool
}

class Pipeline {
    let pipeline: StableDiffusionPipelineProtocol
    let maxSeed: UInt32

    var progress: StableDiffusionProgress? = nil {
        didSet {
            progressPublisher.value = progress
        }
    }
    lazy private(set) var progressPublisher: CurrentValueSubject<StableDiffusionProgress?, Never> = CurrentValueSubject(progress)
    
    private var canceled = false

    init(_ pipeline: StableDiffusionPipelineProtocol, maxSeed: UInt32 = UInt32.max) {
        self.pipeline = pipeline
        self.maxSeed = maxSeed
    }
    
    func resizeImage(_ image: CGImage, targetSize: CGSize) -> CGImage? {
            let width = targetSize.width
            let height = targetSize.height

            guard let colorSpace = image.colorSpace,
                  let context = CGContext(
                    data: nil,
                    width: Int(width),
                    height: Int(height),
                    bitsPerComponent: image.bitsPerComponent,
                    bytesPerRow: 0,
                    space: colorSpace,
                    bitmapInfo: image.bitmapInfo.rawValue
                  ) else {
                return nil
            }

            context.interpolationQuality = .high
            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))

            return context.makeImage()
        }
    
    
    func generate(
        prompt: String,
        scheduler: StableDiffusionScheduler,
        stepCount: Int,
        seed: UInt32 = 0,
        numPreviews previewCount: Int = 5,
        disableSafety: Bool = false,
        startingImage: CGImage? = nil
    ) throws -> GenerationResult {
        canceled = false
        let theSeed = seed > 0 ? seed : UInt32.random(in: 1...maxSeed)
        
        let resizedStartingImage: CGImage? = startingImage.flatMap { resizeImage($0, targetSize: CGSize(width: 512, height: 512)) }
        
        var config = StableDiffusionPipeline.Configuration(prompt: prompt)
        config.stepCount = stepCount
        config.seed = theSeed
        config.disableSafety = disableSafety
        config.schedulerType = scheduler.asStableDiffusionScheduler()
        config.useDenoisedIntermediates = true
        config.startingImage = resizedStartingImage
        
        if startingImage != nil {
            config.strength = 0.7
        }

        // Evenly distribute previews based on inference steps
        let previewIndices = previewIndices(stepCount, previewCount)

        do {
            let images = try pipeline.generateImages(configuration: config) { progress in
                handleProgress(StableDiffusionProgress(progress: progress,
                                                       previewIndices: previewIndices))
                return !canceled
            }
            let image = images.compactMap({ $0 }).first
            return GenerationResult(image: image, lastSeed: theSeed, userCanceled: canceled)

        }
        catch {
            print(error)
        }
       
        return GenerationResult(image: nil, lastSeed: theSeed, userCanceled: canceled)
    }

    func handleProgress(_ progress: StableDiffusionProgress) {
        self.progress = progress
    }
        
    func setCancelled() {
        canceled = true
    }
    
    func cleanup() {
        setCancelled()
        progressPublisher.send(completion: .finished)
        progressPublisher = CurrentValueSubject(nil) // Reiniciar el publisher
    }
}
