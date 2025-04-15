//
//  AllproductViewModelTests.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//

import XCTest
@testable import TraxRetail
import Combine

final class AllproductViewModelTests: XCTestCase {
    
    var viewModel: AllProductViewModel!
    var traxStorage: MockTraxStorage!
    var imageRepository: MockImageRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        traxStorage = MockTraxStorage()
        imageRepository = MockImageRepository()
        cancellables = []
        viewModel = AllProductViewModel(
            traxStorage: traxStorage,
            imageRepository: imageRepository
        )
    }
    
    func testGetProducts() async {
        let expectation = XCTestExpectation(description: "Product should be fetched")
                
        viewModel.$products
            .dropFirst() // Skip the initial value
            .sink { newValue in
                XCTAssertEqual(newValue.count, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.getProducts()

        await fulfillment(of: [expectation])
    }
}
