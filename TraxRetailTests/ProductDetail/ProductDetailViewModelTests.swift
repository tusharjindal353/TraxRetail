//
//  ProductDetailViewModelTests.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 16/04/2025.
//

import XCTest
@testable import TraxRetail
import Combine

final class ProductDetailViewModelTests: XCTestCase {
    
    var viewModel: ProductDetailsViewModel!
    var traxStorage: MockTraxStorage!
    var imageRepository: MockImageRepository!
    var imageRecognisation: MockTraxImageRecognisation!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        traxStorage = MockTraxStorage()
        imageRepository = MockImageRepository()
        imageRecognisation = MockTraxImageRecognisation()
        cancellables = []
        viewModel = ProductDetailsViewModel(
            imageRecognisation: imageRecognisation,
            imageRepository: imageRepository,
            product: traxStorage.mockProduct)
    }
    
    func testRecogniseImage() async {
        imageRecognisation.resultToReturn = .success("Apple")
        let expectation = XCTestExpectation(description: "Image Should be recognise")
                
        viewModel.$imageDescription
            .dropFirst() // Skip the initial value
            .sink { newValue in
                XCTAssertEqual(newValue, "Apple")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.recogniseImage(image: UIImage())

        await fulfillment(of: [expectation])
    }
    
    func testLoadImage() async {
        let expectation = XCTestExpectation(description: "Image Should be loaded")
                
        viewModel.$image
            .dropFirst() // Skip the initial value
            .sink { newValue in
                XCTAssertEqual(newValue, self.imageRepository.imageToReturn)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.loadImage(productId: "")

        await fulfillment(of: [expectation])
    }
}
