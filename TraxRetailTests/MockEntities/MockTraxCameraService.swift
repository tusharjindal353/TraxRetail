//
//  MockTraxCameraService.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//
import TraxCamera
import Combine
import UIKit
import AVFoundation

class MockTraxCameraService: TraxCameraService {
    var isSessionConfigured: Bool = false
    var isPhotoCaptured: Bool = false
    var isFlashOn: Bool = false
    var currentLens: LensMode = .normal
    var imagePublisher = PassthroughSubject<UIImage, Error>().eraseToAnyPublisher()
    var session: AVCaptureSession = AVCaptureSession()
    
    init() { }
    
    func configureSession() {
        isSessionConfigured = true
    }
    
    func startSession() {
    }
    
    func stopSession() {
    }
    
    func capturePhoto(flash: Bool) {
        isPhotoCaptured = true
        isFlashOn = flash
    }
    
    func switchLens(lensMode: TraxCamera.LensMode) {
        currentLens = lensMode
    }
}
