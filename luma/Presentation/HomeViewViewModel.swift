//
//  HomeViewViewModel.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI
import PhotosUI
import BrightroomEngine
import Combine

class HomeViewViewModel: ObservableObject {
    let upscaleImage: UpscaleImageType
    let applyFilter: ApplyFilterType
    let applyTweaks: ApplyTweaksType
    let applyNST: ApplyNSTType
    let removeObject: RemoveObjectType
    let ciContext: CIContext
    
    init(upscaleImage: UpscaleImageType, applyFilter: ApplyFilterType, applyTweaks: ApplyTweaksType, applyNST: ApplyNSTType, removeObject: RemoveObjectType, ciContext: CIContext) {
        self.upscaleImage = upscaleImage
        self.applyFilter = applyFilter
        self.applyTweaks = applyTweaks
        self.applyNST = applyNST
        self.removeObject = removeObject
        self.ciContext = ciContext
        
        anyCancellable = generation.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    //Commit timeline
    @Published var imageCommits: [UIImage] = []
    
    //Current commit index
    @Published var commitIndex: Int?
    
    //Original image selected from Photos App
    @Published var selectedImage: UIImage?
    
    //Displayed image in app
    @Published var displayedImage: UIImage?
    
    //Preview
    @Published var imagePreview: UIImage?
    
    @Published var pickerItem: PhotosPickerItem?
    @Published var loading: Bool = false
    
    //Navigation tabs
    @Published var selectedTab: NavigationTabs = .none
    @Published var selectedStyleTab: StyleTabs = .none
    @Published var selectedFilterTab: FilterTabs = .none
        
    @Published var isModelDownloaded = false
    @Published var showingAlert = false
    
    @Published var isPipelineLoaded = false
    
    @Published var currentView: CurrentView = .homeview

    @Published var stateSubscriber: Cancellable?
    @Published var preparationPhase = "Downloading…"
    @Published var downloadProgress: Double = 0
    
    @Published var generation = GenerationContextManager.shared.genContext
    
    //Inpainting
    @Published var currentLine = Line()
    @Published var lines: [Line] = []
    @Published var linesPreview: [Line] = []

    @Published var thickness: Double = 5.0

    @Published var displayedImageSize: CGSize = .zero
    
    var anyCancellable: AnyCancellable? = nil
    
    @Published var orientation = UIDevice.current.orientation
    
    let orientationChanged = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    @Published var contrast: Double = 1.0
    @Published var saturation: Double = 1.0
    @Published var brightness: Double = 0.0
    
    let loader = GenerationContextManager.shared.loader

    var imageProvider: ImageProvider?
    var editingStack: EditingStack?
    
    @Published var showErrorAlert = false
    var errorMsg: String = ""
    
    func loadImage() async {
        do {
            if let loadedImage = try await pickerItem?.loadTransferable(type: Data.self),
               let uimg = UIImage(data: loadedImage) {
                DispatchQueue.main.async {
                    self.imageCommits.removeAll()
                    self.selectedImage = uimg
                    self.displayedImage = uimg
                    self.imageCommits.append(self.selectedImage!)
                    self.commitIndex = 0
                    self.resetTabs()
                    self.resetTweaks()

                    self.imageProvider = ImageProvider(image: uimg)
                    self.editingStack = EditingStack(imageProvider: self.imageProvider!)
                    self.editingStack?.start()
                }
            }
        } catch {
            showErrorAlert(msg: "Error loading image: \(error)")
        }
    }
}
