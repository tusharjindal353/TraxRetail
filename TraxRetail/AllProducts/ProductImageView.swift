//
//  ProductImageView.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//

import SwiftUI
import Combine

struct ProductImageView: View {
    // MARK: Properties
    let productId: String
    let imageRepository: TraxImageRepository
    @State private var image: UIImage? = nil
    
    init(productId: String, imageRepository: TraxImageRepository) {
        self.productId = productId
        self.imageRepository = imageRepository
    }

    // MARK: View Body
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.gray
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            }
        }
        .onAppear {
            Task {
                await loadImage(productId: productId)
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
