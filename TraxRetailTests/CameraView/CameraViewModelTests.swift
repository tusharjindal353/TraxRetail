//
//  CameraViewModelTests.swift
//  TraxRetailTests
//
//  Created by Tushar Gupta on 15/04/2025.
//

import XCTest
@testable import TraxRetail

final class CameraViewModelTests: XCTestCase {
    
    var cameraViewModel: CameraViewModel!
    let cameraService = MockTraxCameraService()

    override func setUpWithError() throws {
        cameraViewModel = CameraViewModel(cameraService: cameraService)
    }

    func testConfigureCamera() {
        XCTAssertTrue(cameraService.isSessionConfigured)
    }
    
    func testCapturePhotoWithFlash() {
        XCTAssertFalse(cameraService.isPhotoCaptured)
        XCTAssertFalse(cameraService.isFlashOn)
        cameraViewModel.isFlashOn = true
        cameraViewModel.capturePhoto()
        XCTAssertTrue(cameraService.isPhotoCaptured)
        XCTAssertTrue(cameraService.isFlashOn)
    }
    
    func testCapturePhotoWithoutFlash() {
        XCTAssertFalse(cameraService.isPhotoCaptured)
        XCTAssertFalse(cameraService.isFlashOn)
        cameraViewModel.capturePhoto()
        XCTAssertTrue(cameraService.isPhotoCaptured)
        XCTAssertFalse(cameraService.isFlashOn)
    }
}
