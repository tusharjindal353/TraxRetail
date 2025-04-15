//
//  CameraViewModel.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 04/04/2025.
//
import Combine
import AVFoundation
import UIKit
import TraxCamera

class CameraViewModel: ObservableObject {
    private var cameraService: TraxCameraService
    private var cancellables = Set<AnyCancellable>()
    @Published var capturedImage: UIImage? = nil
    @Published var isImageCaptured: Bool = false
    @Published var isFlashOn: Bool = false
    
    var session: AVCaptureSession {
        cameraService.session
    }
    
    init(cameraService: TraxCameraService) {
        self.cameraService = cameraService
        self.cameraService.configureSession()
        bind()
    }
    
    private func bind() {
        cameraService.imagePublisher
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { image in
                self.capturedImage = image
                self.isImageCaptured = true
            }.store(in: &cancellables)
    }
    
    func startSession() {
        Task {
            self.cameraService.startSession()
        }
    }
    
    func stopSession() {
        Task {
            self.cameraService.stopSession()
        }
    }
    
    func switchLens(lensMode: LensMode) {
        self.cameraService.switchLens(lensMode: lensMode)
    }
    
    func capturePhoto() {
        self.cameraService.capturePhoto(flash: isFlashOn)
    }
}
