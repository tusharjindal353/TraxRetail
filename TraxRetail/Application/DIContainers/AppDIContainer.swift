//
//  AppDIContainer.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//

import TraxCamera
import UIKit
import SwiftUI

final class AppDIContainer {
    
    lazy var traxCameraService: TraxCameraService = {
        TraxCameraServiceImpl()
    }()
    
    lazy var traxStorage: TraxStorage = {
        TraxStorageImpl(context: PersistenceController.shared.container.viewContext)
    }()
    
    lazy var imageRepository: TraxImageRepository = {
        TraxImageRepositoryImpl()
    }()
    
    lazy var imageRecognisation: TraxImageRecognisation = {
        TraxImageRecognisationImpl()
    }()
    
    
    // MARK: - Creating APOD Scene DI Container
    func makeCameraSceneDIContainer() -> CameraSceneDIContainer {
        CameraSceneDIContainer(
            traxCameraService: traxCameraService
        )
    }
    
    func makeAllProductSceneDIContainer() -> AllProductsSceneDIContainer {
        AllProductsSceneDIContainer(
            traxStorage: traxStorage,
            imageRepository: imageRepository
        )
    }
    
    func makeAddProductSceneDIContainer() -> AddProductSceneDIContainer {
        AddProductSceneDIContainer(
            traxStorage: traxStorage,
            imageRepository: imageRepository,
            imageRecognisation: imageRecognisation
        )
    }
    
    func makeProductDetailSceneDIContainer() -> ProductDetailSceneDIContainer {
        ProductDetailSceneDIContainer(
            imageRepository: imageRepository,
            imageRecognisation: imageRecognisation
        )
    }
}

final class CameraSceneDIContainer {
    private let traxCameraService: TraxCameraService
    
    init(
        traxCameraService: TraxCameraService
    ) {
        self.traxCameraService = traxCameraService
    }
    
    func makeCameraView() -> CameraView {
        CameraView(cameraViewModel: makeCameraViewModel())
    }
    
    private func makeCameraViewModel() -> CameraViewModel {
        CameraViewModel(cameraService: traxCameraService)
    }
}

final class AllProductsSceneDIContainer {
    private let traxStorage: TraxStorage
    private let imageRepository: TraxImageRepository
    
    init(
        traxStorage: TraxStorage,
        imageRepository: TraxImageRepository
    ) {
        self.traxStorage = traxStorage
        self.imageRepository = imageRepository
    }
    
    func makeAllProductView() -> AllProductView {
        AllProductView(viewModel: makeAllProductViewModel())
    }
    
    private func makeAllProductViewModel() -> AllProductViewModel {
        AllProductViewModel(
            traxStorage: traxStorage,
            imageRepository: imageRepository)
    }
}

final class AddProductSceneDIContainer {
    private let traxStorage: TraxStorage
    private let imageRepository: TraxImageRepository
    private let imageRecognisation: TraxImageRecognisation
    
    
    init(
        traxStorage: TraxStorage,
        imageRepository: TraxImageRepository,
        imageRecognisation: TraxImageRecognisation
    ) {
        self.traxStorage = traxStorage
        self.imageRepository = imageRepository
        self.imageRecognisation = imageRecognisation
    }
    
    func makeAddProductView(image: UIImage, isImageCaptured: Binding<Bool>) -> AddProductView {
        AddProductView(
            viewModel: makeAddProductViewModel(image: image),
            isImageCaptured: isImageCaptured)
    }
    
    func makeAddProductViewModel(image: UIImage) -> AddProductViewModel {
        AddProductViewModel(
            traxStorage: traxStorage,
            imageRepository: imageRepository,
            imageRecognisation: imageRecognisation,
            image: image
        )
    }
}

final class ProductDetailSceneDIContainer {
    private let imageRepository: TraxImageRepository
    private let imageRecognisation: TraxImageRecognisation
    
    init(
        imageRepository: TraxImageRepository,
        imageRecognisation: TraxImageRecognisation
    ) {
        self.imageRepository = imageRepository
        self.imageRecognisation = imageRecognisation
    }
    
    func makeProductDetailView(product: Product) -> ProductDetailView {
        ProductDetailView(viewModel: makeProductDetailViewModel(product: product))
    }
    
    private func makeProductDetailViewModel(product: Product) -> ProductDetailsViewModel {
        ProductDetailsViewModel(
            imageRecognisation: imageRecognisation,
            imageRepository: imageRepository,
            product: product)
    }
}
