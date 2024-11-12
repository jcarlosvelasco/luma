//
//  TopTab.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI
import PhotosUI


struct TopTab: View {
    @ObservedObject private var viewModel: HomeViewViewModel
    @ObservedObject private var generation: GenerationContext
    @ObservedObject private var settingsVM: SettingsViewViewModel

    @State private var togglePreviousButton = false
    @State private var toggleNextButton = false
    
    init(viewModel: HomeViewViewModel, generation: GenerationContext, settingsVM: SettingsViewViewModel) {
        self.viewModel = viewModel
        self.generation = generation
        self.settingsVM = settingsVM
    }
    
    private var shouldDisableDoneButton: Bool {
        if viewModel.selectedTab == .remove {
            return viewModel.loading || viewModel.imagePreview == nil
        } else if viewModel.selectedTab == .generate {
            return !viewModel.isPipelineLoaded || viewModel.loading || viewModel.imagePreview == nil
        } else {
            return viewModel.loading || viewModel.imagePreview == nil
        }
    }
    
    var body: some View {
        HStack {
            if viewModel.selectedTab == .none {
                PhotosPicker(selection: $viewModel.pickerItem, matching: .images) {
                    Label("Open a file", systemImage: "folder")
                }
                .disabled(viewModel.loading == true)
                
                Spacer()
                
                if (viewModel.selectedImage != nil) {
                    Button(action: {
                        withAnimation {
                            togglePreviousButton.toggle()
                            viewModel.setPreviousImageCommit()
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .symbolEffect(.bounce, value: togglePreviousButton)
                    .disabled(viewModel.commitIndex == 0)
                    .disabled(viewModel.loading == true)
                    
                    Button(action: {
                        withAnimation {
                            toggleNextButton.toggle()
                            viewModel.setNextImageCommit()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .symbolEffect(.bounce, value: toggleNextButton)
                    .disabled(viewModel.commitIndex == viewModel.imageCommits.count - 1)
                    .disabled(viewModel.loading == true)
                }
                
                if (!viewModel.imageCommits.isEmpty) {
                    ShareLink(
                        item: Image(uiImage: viewModel.imageCommits[viewModel.commitIndex!]),
                        preview: SharePreview(
                            "Image Preview",
                            image: Image(uiImage: viewModel.imageCommits[viewModel.commitIndex!])
                        )
                    ) {
                        Text("Export")
                    }
                    .disabled(viewModel.loading == true)
                }
                
                NavigationLink {
                    SettingsView(vm: settingsVM)
                } label: {
                    Image(systemName: "gearshape")
                }
            }
            else {
                Button("Cancel") {
                    withAnimation {
                        viewModel.isPipelineLoaded = false
                        viewModel.imagePreview = nil
                        viewModel.selectedTab = .none
                        viewModel.selectedStyleTab = .none
                        viewModel.selectedFilterTab = .none
                        generation.pipeline?.cleanup()
                        generation.cleanup()
                        viewModel.lines = []
                    }
                }
                .disabled(viewModel.selectedTab == .generate ? (!viewModel.isPipelineLoaded || viewModel.loading) : viewModel.loading)
                Spacer()
                
                if (viewModel.selectedTab == .remove) {
                    Button(action: {
                        withAnimation {
                            viewModel.lines = []
                            viewModel.linesPreview = []
                        }
                    }) {
                        Image(systemName: "trash")
                    }
                    .disabled(viewModel.loading || viewModel.linesPreview.isEmpty)
                    
                    Button(action: {
                        withAnimation {
                            if !viewModel.linesPreview.isEmpty {
                                viewModel.linesPreview.remove(at: viewModel.linesPreview.count - 1)
                            }
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .disabled(viewModel.loading || viewModel.lines.isEmpty)
                    .disabled(viewModel.linesPreview.isEmpty)
                    
                    Button(action: {
                        withAnimation {
                            viewModel.linesPreview.append(viewModel .lines[viewModel.linesPreview.count])
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.loading || viewModel.lines.isEmpty)
                    .disabled(viewModel.lines.count == viewModel.linesPreview.count)

                    Spacer()
                }
            
                Button("Done") {
                    withAnimation {
                        switch viewModel.selectedTab {
                        case .crop: break
                        case .filters:
                            Task {
                                await viewModel.createImageCommit(image: viewModel.imagePreview!)
                                viewModel.imagePreview = nil
                            }
                            viewModel.selectedFilterTab = .none
                            viewModel.selectedTab = .none
                            
                        case .none: break
                        case .styles:
                            Task {
                                await viewModel.createImageCommit(image: viewModel.imagePreview!)
                                viewModel.imagePreview = nil
                            }
                            viewModel.selectedStyleTab = .none
                            viewModel.selectedTab = .none
                            
                        case .tweaks:
                            Task {
                                await viewModel.createImageCommit(image: viewModel.imagePreview!)
                                viewModel.resetTweaks()
                                viewModel.imagePreview = nil
                            }
                            viewModel.selectedTab = .none
                            
                        case .generate:
                            Task {
                                if viewModel.displayedImage == nil {
                                    viewModel.selectedImage = viewModel.imagePreview!
                                }
                                await viewModel.createImageCommit(image: viewModel.imagePreview!)
                                viewModel.imagePreview = nil
                                generation.pipeline?.cleanup()
                                generation.cleanup()
                            }
                            viewModel.selectedTab = .none
                            
                        case .upscale:
                            Task {
                                await viewModel.createImageCommit(image: viewModel.imagePreview!)
                                viewModel.imagePreview = nil
                            }
                            viewModel.selectedTab = .none
                        case .remove:
                            Task {
                                await viewModel.createImageCommit(image: viewModel.imagePreview!)
                                viewModel.imagePreview = nil
                            }
                            viewModel.selectedTab = .none
                        }
                    }
                }
                .disabled(shouldDisableDoneButton)
            }
        }
        .padding()
    }
}
