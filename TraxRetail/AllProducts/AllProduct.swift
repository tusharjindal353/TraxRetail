//
//  AllProduct.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 07/04/2025.
//

import SwiftUI
import CoreData

struct AllProductView: View {
    @ObservedObject var viewModel: AllProductViewModel
    @State private var selectedProduct: Product? = nil
    
    init(viewModel: AllProductViewModel) {
        self.viewModel = viewModel
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.products, id: \.productid) { product in
                        NavigationLink(
                            destination: AppFlowCoordinator
                                .shared
                                .productDetailsScene(
                                    product: product
                                )
                        ) {
                            ProductImageView(
                                productId: product.productid!,
                                imageRepository: viewModel.imageRepository
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await viewModel.getProducts()
            }
        }
        .navigationTitle("All Products")
    }
}
