//
//  HomeView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI
import BrightroomUI

struct HomeView: View {
    @ObservedObject private var homeViewVM: HomeViewViewModel
    @ObservedObject private var settingsViewVM: SettingsViewViewModel
    
    init(homeViewVM: HomeViewViewModel, settingsVM: SettingsViewViewModel) {
        self.homeViewVM = homeViewVM
        self.settingsViewVM = settingsVM
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch homeViewVM.currentView  {
                case .loading:
                    ProgressView(homeViewVM.preparationPhase, value: homeViewVM.downloadProgress, total: 1).padding()
                    
                case .error(let message): ErrorPopover(errorMessage: message).transition(.move(edge: .top))
                    
                case .homeview:
                    VStack {
                        if homeViewVM.selectedTab != .crop {
                            TopTab(viewModel: homeViewVM, generation: homeViewVM.generation, settingsVM: settingsViewVM)
                            Divider()
                        }
                        
                        Spacer()
                        
                        if homeViewVM.orientation.isPortrait {
                            VStack {
                                if homeViewVM.selectedTab != .crop && homeViewVM.selectedTab != .remove {
                                    ImageView(viewModel: homeViewVM)
                                }
                            }
                            .onChange(of: homeViewVM.pickerItem) {
                                Task {
                                    await homeViewVM.loadImage()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        else {
                            HStack {
                                if homeViewVM.selectedTab != .crop && homeViewVM.selectedTab != .remove {
                                    ImageView(viewModel: homeViewVM)
                                    
                                    if homeViewVM.selectedTab == .filters {
                                        Spacer()
                                        FiltersTabView(viewModel: homeViewVM)
                                    }
                                    else if homeViewVM.selectedTab == .tweaks {
                                        Spacer()
                                        TweaksView(viewModel: homeViewVM)
                                    }
                                    else if homeViewVM.selectedTab == .styles {
                                        Spacer()
                                        StylesTabView(viewModel: homeViewVM)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            .onChange(of: homeViewVM.pickerItem) {
                                Task {
                                    await homeViewVM.loadImage()
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if homeViewVM.selectedTab == .remove {
                            InpaintingView(viewModel: homeViewVM)
                        }
                        
                        if homeViewVM.selectedTab == .crop {
                            SwiftUIPhotosCropView(
                                editingStack: homeViewVM.editingStack!,
                                onDone: {
                                    Task {
                                        do {
                                            let image: UIImage = try homeViewVM.editingStack!.makeRenderer().render().uiImage
                                            await homeViewVM.createImageCommit(image: image)
                                            homeViewVM.selectedTab = .none
                                        }
                                        catch {
                                            print(error)
                                        }
                                    }
                                },
                                onCancel: {
                                    homeViewVM.selectedTab = .none
                                }
                            )
                        }
                        
                        if homeViewVM.selectedTab == .generate {
                            VStack {
                                HStack {
                                    PromptTextField(text: $homeViewVM.generation.positivePrompt, isPositivePrompt: true, model: iosModel().modelVersion)
                                    
                                    Spacer()
                                    
                                    Button("Generate") {
                                        homeViewVM.submit()
                                    }
                                    .padding(.leading)
                                    .disabled(!homeViewVM.isPipelineLoaded || homeViewVM.loading || homeViewVM.generation.positivePrompt.isEmpty)
                                    .buttonStyle(.borderedProminent)
                                }
                                
                                if (!homeViewVM.isPipelineLoaded) {
                                    ProgressView()
                                }
                                
                                if case .running(let progress) = homeViewVM.generation.state {
                                    if let progress = progress, progress.stepCount > 0 {
                                        let step = Int(progress.step) + 1
                                        let fraction = Double(step) / Double(progress.stepCount)
                                        let label = "Step \(step) of \(progress.stepCount)"
                                        VStack {
                                            if let safeImage = homeViewVM.generation.previewImage {
                                                Image(safeImage, scale: 1, label: Text("generated"))
                                                    .resizable()
                                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                            }
                                            
                                            ProgressView(label, value: fraction, total: 1)
                                                .padding(.vertical)
                                        }
                                    } else {
                                        ProgressView()
                                    }
                                }
                            }
                            .padding()
                            .environmentObject(homeViewVM.generation)
                            .onAppear {
                                Task.init {
                                    if homeViewVM.isModelDownloaded {
                                        do {
                                            homeViewVM.generation.pipeline = try await homeViewVM.loader.prepare()
                                            homeViewVM.currentView = .homeview
                                            homeViewVM.isPipelineLoaded = true
                                        } catch {
                                            homeViewVM.currentView = .error("Could not load model, error: \(error)")
                                        }
                                    }
                                }
                            }
                        }
                        
                        if homeViewVM.orientation.isPortrait {
                            if homeViewVM.selectedTab == .filters {
                                FiltersTabView(viewModel: homeViewVM)
                            }
                            else if homeViewVM.selectedTab == .tweaks {
                                TweaksView(viewModel: homeViewVM)
                            }
                            else if homeViewVM.selectedTab == .styles {
                                StylesTabView(viewModel: homeViewVM)
                            }
                        }
                        
                        Divider()
                        BottomTab(viewModel: homeViewVM, generation: homeViewVM.generation)
                    }
                    .onReceive(homeViewVM.orientationChanged) { _ in
                        homeViewVM.orientation = UIDevice.current.orientation
                    }
                    .onAppear {
                        if let scene = UIApplication.shared.connectedScenes.first,
                           let sceneDelegate = scene as? UIWindowScene,
                           sceneDelegate.interfaceOrientation.isPortrait {
                            homeViewVM.orientation = .portrait
                        } else {
                            homeViewVM.orientation = .landscapeLeft
                        }
                        homeViewVM.isModelDownloaded = homeViewVM.loader.ready
                    }
                }
            }
            .alert(homeViewVM.errorMsg, isPresented: $homeViewVM.showErrorAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
