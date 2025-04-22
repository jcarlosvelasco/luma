//
//  UseCaseModule.swift
//  luma
//
//  Created by Juan Carlos Velasco on 22/4/25.
//

import Factory

extension Container {
    var applyFilterUC: Factory<ApplyFilterType> {
        self {
            ApplyFilter(repo: Container.shared.applyFiltersRepository())
        }
        .singleton
    }
    
    var applyNSTUC: Factory<ApplyNSTType> {
        self {
            ApplyNST(repo: Container.shared.applyNSTRepository())
        }
        .singleton
    }
    
    var upscaleImageUC: Factory<UpscaleImageType> {
        self {
            UpscaleImage(repo: Container.shared.imageUpscalerRepository())
        }
        .singleton
    }
    
    var applyTweaksUC: Factory<ApplyTweaksType> {
        self {
            ApplyTweaks(repo: Container.shared.applyTweaksRepository())
        }
        .singleton
    }
    
    var removeObjectUC: Factory<RemoveObjectType> {
        self {
            RemoveObjectUC(repo: Container.shared.removeObjectRepository())
        }
        .singleton
    }
}
