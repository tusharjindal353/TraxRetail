//
//  ProductDetailView.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//

import SwiftUI

struct ProductDetailView: View {
    
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    init(
        viewModel: ProductDetailsViewModel
    ) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding()
            }
            Text(viewModel.productName)
            Text(viewModel.productCategory)
            Spacer()
            Button(action: {
                Task {
                    if let image = viewModel.image {
                        await viewModel.recogniseImage(image: image)
                    }
                }
            }) {
                Text("Classify Image")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding(.vertical, 16)
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
                    
            }
        }
        .onReceive(viewModel.$image) { newImage in
            print("Image updated:", newImage != nil)
        }
        .onAppear {
            Task {
                await viewModel.loadImage(productId: viewModel.productId!)
            }
        }
        .alert("Data Prediction", isPresented: $viewModel.showImageRecognisitionResult) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.imageDescription ?? "")
        }
        .navigationTitle("Product Details")
        .padding()
    }
    
}
