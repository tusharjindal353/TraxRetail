//
//  AppCoordinator.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//

import SwiftUI
import Combine

final class AppFlowCoordinator {
    static let shared = AppFlowCoordinator(appDIContainer: AppDIContainer())
    private let appDIContainer: AppDIContainer
    
    init(
        appDIContainer: AppDIContainer
    ) {
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Start of the flow in AppFlowCoordinator
    func start() -> AnyView {
        // We can check if user need to authenticate or not and based on this information, we can open different flows from here
        AnyView(
            cameraScene()
        )
    }
    
    func cameraScene() -> CameraView {
        appDIContainer
            .makeCameraSceneDIContainer()
            .makeCameraView()
    }
    
    func addProductScene(
        image: UIImage,
        isImageCaptured: Binding<Bool>
    ) -> AddProductView {
        appDIContainer
            .makeAddProductSceneDIContainer()
            .makeAddProductView(
                image: image,
                isImageCaptured: isImageCaptured
            )
    }
    
    func allProductScene() -> AllProductView {
        appDIContainer
            .makeAllProductSceneDIContainer()
            .makeAllProductView()
    }
    
    func productDetailsScene(product: Product) -> ProductDetailView {
        appDIContainer
            .makeProductDetailSceneDIContainer()
            .makeProductDetailView(product: product)
    }
}
