//
//  AllProductViewModel.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 14/04/2025.
//

import Combine
import Foundation
import UIKit

class AllProductViewModel: ObservableObject {
    private let traxStorage: TraxStorage
    let imageRepository: TraxImageRepository
    @Published var products: [Product] = []
    @Published var productImages: [String: UIImage] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        traxStorage: TraxStorage,
        imageRepository: TraxImageRepository
    ) {
        self.traxStorage = traxStorage
        self.imageRepository = imageRepository
    }
    
    func getProducts() async {
        let result = await traxStorage.getProducts()
        switch result {
        case .success(let success):
            DispatchQueue.main.async {
                self.products = success
            }
        case .failure(let failure):
            print(failure)
        }
    }
}
