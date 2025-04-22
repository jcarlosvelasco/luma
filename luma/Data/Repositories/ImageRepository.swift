//
//  ImageRepository.swift
//  luma
//
//  Created by Juan Carlos Velasco on 22/4/25.
//

import UIKit

class ImageRepository:
    ApplyTweaksRepositoryType,
    ApplyFilterRepositoryType,
    ApplyNSTRepositoryType,
    RemoveObjectRepositoryType,
    UpscaleImageRepositoryType
{
    private let applyFilter: ApplyFiltersInfrastructureType
    private let errorMapper: ImageDomainErrorMapper
    private let applyNST: ApplyNSTInfrType
    private let applyTweaks: ApplyTweaksInfrType
    private let removeObjectType: RemoveObjectImplType
    private let imageUpscalerModel: ImageUpscalerInfrastructureType
    
    init(
        applyFilter: ApplyFiltersInfrastructureType,
        errorMapper: ImageDomainErrorMapper,
        applyNST: ApplyNSTInfrType,
        applyTweaks: ApplyTweaksInfrType,
        removeObjectType: RemoveObjectImplType,
        imageUpscalerModel: ImageUpscalerInfrastructureType
    ) {
        self.applyFilter = applyFilter
        self.errorMapper = errorMapper
        self.applyNST = applyNST
        self.applyTweaks = applyTweaks
        self.removeObjectType = removeObjectType
        self.imageUpscalerModel = imageUpscalerModel
    }
    
    func applyFilter(image: UIImage, filter: FilterType) -> Result<UIImage, ImageDomainError> {
        let result = applyFilter.addFilter(image: image, filter: filter)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
    
    func applyNST(image: UIImage, style: NSTStyle) async -> Result<UIImage, ImageDomainError> {
        let result = await applyNST.applyFilters(image: image, style: style)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
    
    func applyTweaks(image: UIImage, tweaks: Tweaks) -> Result<UIImage, ImageDomainError> {
        let result = applyTweaks.applyTweaks(image: image, tweaks: tweaks)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
    
    func removeObject(image: UIImage, mask: UIImage) async -> Result<UIImage, ImageDomainError> {
        let result = await removeObjectType.doInpainting(image: image, mask: mask)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
    
    func upscaleImage(image: UIImage) async -> Result<UIImage, ImageDomainError> {
        let result = await imageUpscalerModel.upscaleImage(image: image)
        
        guard let image = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(image)
    }
}
