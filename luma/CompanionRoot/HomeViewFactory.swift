//
//  HomeViewFactory.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation
import CoreImage

class HomeViewFactory {
    static func create() -> HomeView {
        let context = CIContext()
        let errorMapper = ImageDomainErrorMapper()
        
        let upscaleImageUC = createUpscaleUC(context: context, errorMapper: errorMapper)
        let applyFilterUC = createApplyFilterUC(context: context, errorMapper: errorMapper)
        let applyTweaksUC = createApplyTweaksUC(context: context, errorMapper: errorMapper)
        let applyNSTUC = createApplyNSTUC(context: context, errorMapper: errorMapper)
        let removeObjectUC = createRemoveObjectUC(context: context, errorMapper: errorMapper)
        
        let homeViewViewModel = HomeViewViewModel(upscaleImage: upscaleImageUC, applyFilter: applyFilterUC, applyTweaks: applyTweaksUC, applyNST: applyNSTUC, removeObject: removeObjectUC, ciContext: context)
        return HomeView(homeViewVM: homeViewViewModel, settingsVM: SettingsViewViewModel())
    }
    
    private static func createUpscaleUC(context: CIContext, errorMapper: ImageDomainErrorMapper) -> UpscaleImageType {
        let imageUtils = ImageUtils(context: context)
        let upscaler = ImageUpscaler(imageUtils: imageUtils)
        let upscaleImageRepo = ImageUpscaleRepository(imageUpscalerModel: upscaler, errorMapper: errorMapper)
        return UpscaleImage(repo: upscaleImageRepo)
    }
    
    private static func createApplyFilterUC(context: CIContext, errorMapper: ImageDomainErrorMapper) -> ApplyFilterType {
        let filters = ApplyFilters(context: context)
        let errorMapper = ImageDomainErrorMapper()
        let repo = ApplyFilterRepository(filter: filters, errorMapper: errorMapper)
        return ApplyFilter(repo: repo)
    }
    
    private static func createApplyTweaksUC(context: CIContext, errorMapper: ImageDomainErrorMapper) -> ApplyTweaksType {
        let tweaks = ApplyTweaksInfrImpl(context: context)
        let repo = ApplyTweaksRepository(tweaks: tweaks, errorMapper: errorMapper)
        return ApplyTweaks(repo: repo)
    }
    
    private static func createApplyNSTUC(context: CIContext, errorMapper: ImageDomainErrorMapper) -> ApplyNSTType {
        let imageUtils = ImageUtils(context: context)
        let nst = ApplyNSTInfrImpl(imageUtils: imageUtils)
        let repo = ApplyNSTRepository(applyNST: nst, errorMapper: errorMapper)
        return ApplyNST(repo: repo)
    }
    
    private static func createRemoveObjectUC(context: CIContext, errorMapper: ImageDomainErrorMapper) -> RemoveObjectType {
        let imageUtils = ImageUtils(context: context)
        let remove = RemoveObject(imageUtils: imageUtils)
        let repo = RemoveObjectRepository(removeObjectType: remove, errorMapper: errorMapper)
        return RemoveObjectUC(repo: repo)
    }
}
