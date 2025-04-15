//
//  AddProductView.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 07/04/2025.
//
import SwiftUI

struct AddProductView: View {
    
    @State private var productName: String = ""
    @State private var category: String = ""
    @Binding var isImageCaptured: Bool
    @ObservedObject var viewModel: AddProductViewModel
    
    init(
        viewModel: AddProductViewModel,
        isImageCaptured: Binding<Bool>
    ) {
        self.viewModel = viewModel
        self._isImageCaptured = isImageCaptured
    }

    var body: some View {
        VStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding()
            TextField("Enter Product name", text: $productName)
                .textFieldStyle(.roundedBorder)
            TextField("Enter Category name", text: $category)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Button(action: {
                Task {
                    await viewModel.recogniseImage(image: viewModel.image)
                }
            }) {
                Text("Classify Image")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding(.vertical, 16)
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
                    
            }
            Button(action: {
                Task {
                    await viewModel.saveProduct(
                        productName: productName,
                        productCategory: category
                    )
                }
            }) {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding(.vertical, 16)
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
                    
            }
        }
        .alert("Data Prediction", isPresented: $viewModel.showImageRecognisitionResult) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.imageDescription ?? "")
        }
        .alert("Product Saved", isPresented: $viewModel.isProductSaved) {
            Button("OK", role: .cancel) {
                isImageCaptured.toggle()
            }
        }
        .navigationTitle("Add New Product")
        .padding()
    }
    
}
