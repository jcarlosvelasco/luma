//
//  RepositoryModule.swift
//  luma
//
//  Created by Juan Carlos Velasco on 22/4/25.
//

import Factory


extension Container {
    private var imageRepository: Factory<ImageRepository> {
        self {
            ImageRepository(
                applyFilter: Container.shared.applyFilters(),
                errorMapper: Container.shared.imageDomainErrorMapper(),
                applyNST: Container.shared.applyNST(),
                applyTweaks: Container.shared.applyTweaks(),
                removeObjectType: Container.shared.removeObject(),
                imageUpscalerModel: Container.shared.imageUpscaler()
            )
        }
        .singleton
    }
    
    var applyFiltersRepository: Factory<ApplyFilterRepositoryType> {
        self {
            self.imageRepository()
        }
        .singleton
    }
    
    var applyNSTRepository: Factory<ApplyNSTRepositoryType> {
        self {
            self.imageRepository()
        }
        .singleton
    }
    
    var applyTweaksRepository: Factory<ApplyTweaksRepositoryType> {
        self {
            self.imageRepository()
        }
        .singleton
    }
    
    var removeObjectRepository: Factory<RemoveObjectRepositoryType> {
        self {
            self.imageRepository()
        }
        .singleton
    }
    
    var imageUpscalerRepository: Factory<UpscaleImageRepositoryType> {
        self {
            self.imageRepository()
        }
        .singleton
    }
}
