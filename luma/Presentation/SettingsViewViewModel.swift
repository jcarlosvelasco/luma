//
//  SettingsViewViewModel.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation

class SettingsViewViewModel: ObservableObject {
    let qualityModes = ["Low", "Medium", "High"]

    @Published var qualityMode = "Medium"
    @Published var genContext = GenerationContextManager.shared.genContext
    @Published var showingAlert = false
    
    let loader = GenerationContextManager.shared.loader
    @Published var modelDownloaded = false

    init() {
        loadQualityMode()
    }
    
    private func loadQualityMode() {
        let result = genContext.steps
        
        switch result {
            case 10:
                qualityMode = "Low"
            case 15:
                qualityMode = "Medium"
            case 20:
                qualityMode = "High"
            default:
                break
        }
    }
    
    func checkStatus() {
        modelDownloaded = loader.ready || loader.downloaded
    }
    
    func setQualityMode() {
        switch qualityMode {
            case "Low":
                Settings.shared.stepCount = 10
                genContext.steps = 10
            case "Medium":
                Settings.shared.stepCount = 15
                genContext.steps = 15
            case "High":
                Settings.shared.stepCount = 20
                genContext.steps = 20
            default:
                break
        }
    }
    
    func onDeleteImage2ImageModel() {
        PipelineLoader.removeAll()
        checkStatus()
    }
}
