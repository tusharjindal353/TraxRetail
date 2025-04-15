//
//  AddProductViewModel.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//

import UIKit
import Combine

class AddProductViewModel: ObservableObject {
    
    private let traxStorage: TraxStorage
    private let imageRepository: TraxImageRepository
    private let imageRecognisation: TraxImageRecognisation
    let image: UIImage
    
    @Published var isProductSaved: Bool = false
    @Published var showImageRecognisitionResult: Bool = false
    @Published var imageDescription: String? = nil
    
    init(
        traxStorage: TraxStorage,
        imageRepository: TraxImageRepository,
        imageRecognisation: TraxImageRecognisation,
        image: UIImage
    ) {
        self.traxStorage = traxStorage
        self.imageRepository = imageRepository
        self.imageRecognisation = imageRecognisation
        self.image = image
    }
    
    func saveProduct(
        productName: String,
        productCategory: String
    ) async {
        let productId = UUID().uuidString
        let imageUrl = await saveImage(image: image, productId: productId)
        let result = await traxStorage.saveProduct(
            productId: productId,
            productName: productName,
            productCategory: productCategory,
            productImageUrl: imageUrl
        )
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch result {
            case .success:
                isProductSaved = true
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func saveImage(image: UIImage, productId: String) async -> String {
        let imageUrl = await imageRepository.saveImage(image, id: productId)
        return imageUrl ?? ""
    }
    
    func recogniseImage(image: UIImage) async {
        let result = await imageRecognisation.recogniseImage(image: image)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.imageDescription = success
                self.showImageRecognisitionResult = true
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
