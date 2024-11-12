//
//  BottomTab.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct BottomTab: View {
    @ObservedObject var viewModel: HomeViewViewModel
    @ObservedObject var generation: GenerationContext
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                
                BottomTabButton(
                    text: "GENERATE",
                    action: {
                        if !viewModel.isModelDownloaded {
                            viewModel.showingAlert = true
                        }
                        else {
                            viewModel.setNavigationTab(tab: .generate)
                        }
                    },
                    tab: .generate,
                    viewModel: viewModel,
                    disabledCondition: viewModel.loading
                )
                .alert("In order to use this feature, the app needs to download a model. Make sure you have an internet connection. It may take minutes.", isPresented: $viewModel.showingAlert) {
                    Button("Not now", role: .cancel) {
                        
                    }
                    Button("OK", role: nil) {
                        viewModel.currentView = .loading
                        Task {
                            viewModel.stateSubscriber = viewModel.loader.statePublisher.sink { state in
                                DispatchQueue.main.async {
                                    switch state {
                                    case .downloading(let progress):
                                        viewModel.preparationPhase = "Downloading"
                                        viewModel.downloadProgress = progress
                                    case .uncompressing:
                                        viewModel.preparationPhase = "Uncompressing"
                                        viewModel.downloadProgress = 1
                                    case .readyOnDisk:
                                        viewModel.preparationPhase = "Loading"
                                        viewModel.downloadProgress = 1
                                    default:
                                        break
                                    }
                                }
                            }
                            do {
                                generation.pipeline = try await viewModel.loader.prepare()
                                viewModel.isPipelineLoaded = true
                                viewModel.currentView = .homeview
                             } catch {
                                viewModel.currentView = .error("Could not load model, error: \(error)")
                            }
                        }
                    }
                }
                
                BottomTabButton(
                    text: "UPSCALE",
                    action: {
                        viewModel.setNavigationTab(tab: .upscale)
                        Task {
                            await viewModel.upscaleImage()
                        }
                    },
                    tab: .upscale,
                    viewModel: viewModel,
                    disabledCondition: (viewModel.displayedImage == nil || viewModel.loading == true)
                )
                
                BottomTabButton(
                    text: "STYLES",
                    action: {
                        viewModel.setNavigationTab(tab: .styles)
                    },
                    tab: .styles,
                    viewModel: viewModel,
                    disabledCondition: (viewModel.displayedImage == nil || viewModel.loading == true)
                )
                
                BottomTabButton(
                    text: "TWEAKS",
                    action: { viewModel.setNavigationTab(tab: .tweaks)},
                    tab: .tweaks,
                    viewModel: viewModel,
                    disabledCondition: (viewModel.displayedImage == nil || viewModel.loading == true)
                )
                
                BottomTabButton(
                    text: "CROP",
                    action: { viewModel.setNavigationTab(tab: .crop)},
                    tab: .crop,
                    viewModel: viewModel,
                    disabledCondition: (viewModel.displayedImage == nil || viewModel.loading == true)
                )
                
                BottomTabButton(
                    text: "FILTERS",
                    action: { viewModel.setNavigationTab(tab: .filters)},
                    tab: .filters,
                    viewModel: viewModel,
                    disabledCondition: (viewModel.displayedImage == nil || viewModel.loading == true)
                )
                
                BottomTabButton(
                    text: "REMOVE",
                    action: { withAnimation {viewModel.setNavigationTab(tab: .remove)}},
                    tab: .remove,
                    viewModel: viewModel,
                    disabledCondition: (viewModel.displayedImage == nil || viewModel.loading == true)
                )
            }
        }
        .padding()
    }
}
