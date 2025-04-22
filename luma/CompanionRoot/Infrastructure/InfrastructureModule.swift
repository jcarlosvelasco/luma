//
//  InfrastructureModule.swift
//  luma
//
//  Created by Juan Carlos Velasco on 22/4/25.
//

import Factory
import CoreImage

extension Container {
    var imageUpscaler: Factory<ImageUpscalerInfrastructureType> {
        self {
            ImageUpscaler(
                imageUtils: self.imageUtils()
            )
        }
        .singleton
    }
    
    var applyFilters: Factory<ApplyFiltersInfrastructureType> {
        self {
            ApplyFilters(context: Container.shared.ciContext())
        }
        .singleton
    }
    
    var applyNST: Factory<ApplyNSTInfrType> {
        self {
            ApplyNSTInfrImpl(imageUtils: Container.shared.imageUtils())
        }
        .singleton
    }
    
    var applyTweaks: Factory<ApplyTweaksInfrType> {
        self {
            ApplyTweaksInfrImpl(context: Container.shared.ciContext())
        }
        .singleton
    }
    
    var removeObject: Factory<RemoveObjectImplType> {
        self {
            RemoveObject(imageUtils: self.imageUtils())
        }
        .singleton
    }
    
    private var imageUtils: Factory<ImageUtils> {
        self {
            ImageUtils(context: Container.shared.ciContext())
        }
        .singleton
    }
    
    var ciContext: Factory<CIContext> {
        self {
            CIContext()
        }
        .singleton
    }
}
