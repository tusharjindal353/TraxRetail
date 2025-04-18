//
//  AddProductViewModelTests.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//

import XCTest
@testable import TraxRetail
import Combine

final class AddProductViewModelTests: XCTestCase {
    
    var viewModel: AddProductViewModel!
    var traxStorage: MockTraxStorage!
    var imageRepository: MockImageRepository!
    var imageRecognisation: MockTraxImageRecognisation!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        traxStorage = MockTraxStorage()
        imageRepository = MockImageRepository()
        imageRecognisation = MockTraxImageRecognisation()
        cancellables = []
        viewModel = AddProductViewModel(
            traxStorage: traxStorage,
            imageRepository: imageRepository,
            imageRecognisation: imageRecognisation,
            image: UIImage()
        )
    }
    
    func testSaveProduct() async {
        let expectation = XCTestExpectation(description: "Products should be saved")
                
        viewModel.$isProductSaved
            .dropFirst() // Skip the initial value
            .sink { newValue in
                XCTAssertEqual(newValue, true)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.saveProduct(productName: "Apple", productCategory: "fruit")

        await fulfillment(of: [expectation])
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
}
