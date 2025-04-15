//
//  ProductDetailsViewModel.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//
import Combine
import UIKit

class ProductDetailsViewModel: ObservableObject {
    @Published var showImageRecognisitionResult: Bool = false
    @Published var imageDescription: String? = nil
    @Published var image: UIImage? = nil
    
    private var imageRecognisation: TraxImageRecognisation
    let imageRepository: TraxImageRepository
    private let product: Product
    
    var productId: String? {
        product.productid
    }
    
    var productName: String {
        product.productname ?? "Product name not found"
    }
    
    var productCategory: String {
        product.category ?? "Product category not found"
    }
    
    var productImageUrl: String? {
        product.image
    }
    
    init(
        imageRecognisation: TraxImageRecognisation,
        imageRepository: TraxImageRepository,
        product: Product
    ) {
        self.imageRecognisation = imageRecognisation
        self.imageRepository = imageRepository
        self.product = product
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
    
    func loadImage(productId: String) async {
        let image = await imageRepository.getImage(productId: productId)
        DispatchQueue.main.async {
            self.image = image
        }
    }
}
