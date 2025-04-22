//
//  ImageApp2Tests.swift
//  ImageApp2Tests
//
//  Created by Juan Carlos Velasco on 14/8/24.
//

import XCTest
@testable import luma

final class ImageApp2Tests: XCTestCase {
    var vm: HomeViewViewModel!
    var errorVM: HomeViewViewModel!
    
    private func createUpscaleUC() -> UpscaleImageType {
        let upscaleImageRepo = ImageUpscaleFakeRepo()
        return UpscaleImage(repo: upscaleImageRepo)
    }
    
    private func createApplyFilterUC() -> ApplyFilterType {
        let repo = ApplyFilterFakeRepo()
        return ApplyFilter(repo: repo)
    }
    
    private func createApplyTweaksUC() -> ApplyTweaksType {
        let repo = ApplyTweaksFakeRepo()
        return ApplyTweaks(repo: repo)
    }
    
    private func createApplyNSTUC() -> ApplyNSTType {
        let repo = ApplyNSTFakeRepo()
        return ApplyNST(repo: repo)
    }
    
    private func createRemoveObjectUC() -> RemoveObjectType {
        let repo = RemoveObjectFakeRepo()
        return RemoveObjectUC(repo: repo)
    }
    
    private func createApplyFilterErrorUC() -> ApplyFilterType {
        let repo = ApplyFilterFakeRepoError()
        return ApplyFilter(repo: repo)
    }
    
    private func createHappyPathVM() -> HomeViewViewModel {
        let context = CIContext()
        let errorMapper = ImageDomainErrorMapper()
        
        let upscaleImageUC = createUpscaleUC()
        let applyFilterUC = createApplyFilterUC()
        let applyTweaksUC = createApplyTweaksUC()
        let applyNSTUC = createApplyNSTUC()
        let removeObjectUC = createRemoveObjectUC()
        
        return HomeViewViewModel(upscaleImage: upscaleImageUC, applyFilter: applyFilterUC, applyTweaks: applyTweaksUC, applyNST: applyNSTUC, removeObject: removeObjectUC, ciContext: context)
    }
    
    private func createErrorVM() -> HomeViewViewModel {
        let context = CIContext()
        let errorMapper = ImageDomainErrorMapper()
        
        let upscaleImageUC = createUpscaleUC()
        let applyFilterUC = createApplyFilterErrorUC()
        let applyTweaksUC = createApplyTweaksUC()
        let applyNSTUC = createApplyNSTUC()
        let removeObjectUC = createRemoveObjectUC()
        
        return HomeViewViewModel(upscaleImage: upscaleImageUC, applyFilter: applyFilterUC, applyTweaks: applyTweaksUC, applyNST: applyNSTUC, removeObject: removeObjectUC, ciContext: context)
    }
    
    override func setUpWithError() throws {
        vm = createHappyPathVM()
        vm.displayedImage = CreateImage.createImage()
        
        errorVM = createErrorVM()
        errorVM.displayedImage = CreateImage.createImage()
    }

    override func tearDownWithError() throws {
        vm = nil
    }

    func testUpscaleImageHappyPath() async throws {
        XCTAssertNil(vm.imagePreview)
        let expectation = XCTestExpectation(description: "Expects imagePreview not to be nil")
        await vm.upscaleImage()
        expectation.fulfill()
        await fulfillment(of: [expectation])
        XCTAssertNotNil(vm.imagePreview)
    }
    
    func testApplyNSTHappyPath() async throws {
        XCTAssertNil(vm.imagePreview)
        let expectation = XCTestExpectation(description: "Expects imagePreview not to be nil")
        await vm.setStyle(.mosaic)
        expectation.fulfill()
        await fulfillment(of: [expectation])
        XCTAssertNotNil(vm.imagePreview)
    }
    
    func testApplyFilterHappyPath() async throws {
        XCTAssertNil(vm.imagePreview)
        let expectation = XCTestExpectation(description: "Expects imagePreview not to be nil")
        await vm.applyFilter(filter: .Chrome)
        expectation.fulfill()
        await fulfillment(of: [expectation])
        XCTAssertNotNil(vm.imagePreview)
    }
    
    func testApplyTweaksHappyPath() async throws {
        XCTAssertNil(vm.imagePreview)
        vm.commitIndex = 0
        vm.imageCommits.append(vm.displayedImage!)
        
        let expectation = XCTestExpectation(description: "Expects imagePreview not to be nil")
        await vm.applyTweaks()
        expectation.fulfill()
        await fulfillment(of: [expectation])
        XCTAssertNotNil(vm.imagePreview)
    }
    
    func testRemoveObjectFakeRepo() async throws {
        XCTAssertNil(vm.imagePreview)
        let expectation = XCTestExpectation(description: "Expects imagePreview not to be nil")
        await vm.doInpainting()
        expectation.fulfill()
        await fulfillment(of: [expectation])
        XCTAssertNotNil(vm.imagePreview)
    }
    
    func testApplyFilterModelError() async throws {
        XCTAssertNil(errorVM.imagePreview)
        let expectation = XCTestExpectation(description: "Expects model error")
        await errorVM.applyFilter(filter: .Chrome)
        expectation.fulfill()
        await fulfillment(of: [expectation])
        XCTAssertNil(errorVM.imagePreview)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
