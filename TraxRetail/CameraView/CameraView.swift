import SwiftUI
import AVFoundation
import TraxCamera

// MARK: - Camera View
struct CameraView: View {
    @ObservedObject private var cameraViewModel: CameraViewModel
    @State private var showAllPhotos = false
    @State private var currentLensMode: LensMode = .normal
    
    init(cameraViewModel: CameraViewModel) {
        self.cameraViewModel = cameraViewModel
    }
    
    var body: some View {
        NavigationStack {
            TraxCameraPreview(session: cameraViewModel.session)
            VStack {
                Spacer()
                VStack {
                    Button(action: {
                        currentLensMode = currentLensMode == .normal ? .ultraWide : .normal
                        cameraViewModel.switchLens(lensMode: currentLensMode)
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text(
                                    currentLensMode == .normal
                                    ? "1.0"
                                    : "0.5"
                                )
                            )
                    }
                    HStack {
                        
                        Button(action: {
                            cameraViewModel.isFlashOn.toggle()
                        }) {
                            Image(
                                systemName: cameraViewModel.isFlashOn
                                ? "bolt.circle.fill"
                                : "bolt.slash.circle"
                            )
                            .font(.system(size: 20))
                            .imageScale(.large)
                            .foregroundStyle(.white)
                            
                        }
                        Button(action: {
                            cameraViewModel.capturePhoto()
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.gray,
                                            lineWidth: 2
                                        )
                                        .padding(.all, 4)
                                )
                        }
                        Button(action: {
                            self.showAllPhotos.toggle()
                        }) {
                            Image(systemName: "photo.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 30, height: 30)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $cameraViewModel.isImageCaptured, destination: {
                if let image = cameraViewModel.capturedImage {
                    AppFlowCoordinator
                        .shared
                        .addProductScene(
                            image: image,
                            isImageCaptured: $cameraViewModel.isImageCaptured
                        )
                }
            })
            .navigationDestination(isPresented: $showAllPhotos, destination: {
                AppFlowCoordinator
                    .shared
                    .allProductScene()
            })
        }
        .onAppear {
            cameraViewModel.startSession()
        }
        .onDisappear {
            cameraViewModel.stopSession()
        }
    }
}

