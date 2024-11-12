//
//  GenerationContextManager.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation

class GenerationContextManager {
    static let shared = GenerationContextManager()

    let genContext: GenerationContext
    let loader: PipelineLoader

    private init() {
        genContext = GenerationContext()
        loader = PipelineLoader(model: iosModel())
    }
}

let genContext = GenerationContextManager.shared.genContext
let loader = GenerationContextManager.shared.loader
