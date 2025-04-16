//
//  TraxCameraPreview.swift
//  TraxCamera
//
//  Created by Tushar Gupta on 10/04/2025.
//

import UIKit
import SwiftUI
import AVFoundation

@available(iOS 13.0, *)
public struct TraxCameraPreview: UIViewRepresentable {
    public let session: AVCaptureSession
    
    public init(session: AVCaptureSession) {
        self.session = session
    }

    public func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}
