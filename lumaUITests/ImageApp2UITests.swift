//
//  ImageApp2UITests.swift
//  ImageApp2UITests
//
//  Created by Juan Carlos Velasco on 19/8/24.
//

import XCTest

final class ImageApp2UITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testUpscaleButtonIsDisabled() throws {
        let button = app.buttons["UPSCALE"]
        XCTAssertTrue(button.exists, "UPSCALE button should exist")
        XCTAssertFalse(button.isEnabled, "UPSCALE button should be disabled")
    }
    
    func testStylesButtonIsDisabled() throws {
        let button = app.buttons["STYLES"]
        XCTAssertTrue(button.exists, "STYLES button should exist")
        XCTAssertFalse(button.isEnabled, "STYLES button should be disabled")
    }
    
    func testTweaksButtonIsDisabled() throws {
        let button = app.buttons["TWEAKS"]
        XCTAssertTrue(button.exists, "TWEAKS button should exist")
        XCTAssertFalse(button.isEnabled, "TWEAKS button should be disabled")
    }
    
    func testCropButtonIsDisabled() throws {
        let button = app.buttons["CROP"]
        XCTAssertTrue(button.exists, "CROP button should exist")
        XCTAssertFalse(button.isEnabled, "CROP button should be disabled")
    }
    
    func testFiltersButtonIsDisabled() throws {
        let button = app.buttons["FILTERS"]
        XCTAssertTrue(button.exists, "FILTERS button should exist")
        XCTAssertFalse(button.isEnabled, "FILTERS button should be disabled")
    }
    
    func testRemoveButtonIsDisabled() throws {
        let button = app.buttons["REMOVE"]
        XCTAssertTrue(button.exists, "REMOVE button should exist")
        XCTAssertFalse(button.isEnabled, "REMOVE button should be disabled")
    }
}
