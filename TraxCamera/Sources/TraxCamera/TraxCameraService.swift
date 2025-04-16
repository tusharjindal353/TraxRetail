//
//  TraxCameraService.swift
//  TraxCamera
//
//  Created by Tushar Gupta on 10/04/2025.
//
import AVFoundation
import Combine
import UIKit

public enum LensMode {
    case normal
    case ultraWide
}

public protocol TraxCameraService {
    func configureSession()
    func startSession()
    func stopSession()
    func capturePhoto(flash: Bool)
    func switchLens(lensMode: LensMode)
    var imagePublisher: AnyPublisher<UIImage, Error> { get }
    var session: AVCaptureSession { get }
}

public class TraxCameraServiceImpl: NSObject, TraxCameraService, AVCapturePhotoCaptureDelegate {
    private var imageSubject = PassthroughSubject<UIImage, Error>()
    public var imagePublisher: AnyPublisher<UIImage, Error> {
        self.imageSubject.eraseToAnyPublisher()
    }
    public let session: AVCaptureSession
    private let output: AVCapturePhotoOutput
    
    
    public init(
        session: AVCaptureSession = AVCaptureSession(),
        output: AVCapturePhotoOutput = AVCapturePhotoOutput()
    ) {
        self.session = session
        self.output = output
    }
    
    public func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Failed to access camera")
            return
        }

        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(output) { session.addOutput(output) }
        
        session.commitConfiguration()
    }
    
    public func startSession() {
        self.session.startRunning()
    }
    
    public func stopSession() {
        self.session.stopRunning()
    }
    
    public func capturePhoto(flash: Bool) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flash ? .on : .off
        output.capturePhoto(with: settings, delegate: self)
    }
    
    public func switchLens(lensMode: LensMode) {
        session.beginConfiguration()
        let currentInput = session.inputs.first
        session.removeInput(currentInput!)
        
        guard let camera = AVCaptureDevice.default(lensMode == .ultraWide ? .builtInUltraWideCamera : .builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Failed to access camera")
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
    }
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Error capturing photo")
            return
        }
        self.imageSubject.send(image)
    }
}
