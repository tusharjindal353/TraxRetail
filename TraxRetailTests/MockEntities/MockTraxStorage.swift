//
//  MockTraxStorage.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//
@testable import TraxRetail
import Foundation
import CoreData
import XCTest

class MockTraxStorage: TraxStorage {
    var date = Date()
    var savedProduct: Product? = nil
    
    var context: NSManagedObjectContext!
    
    init() {
        setUp()
    }

    func setUp() {
        let container = NSPersistentContainer(name: "TraxRetail") // replace with your CoreData model name
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext
    }
    
    func getProducts() async -> Result<[TraxRetail.Product], any Error> {
        let product = Product(context: context)
        product.productid = "123"
        product.category = "fruit"
        product.image = "imageUrl"
        product.productname = "Apple"
        product.date = date
        
        return .success([product])
    }
    
    func saveProduct(productId: String, productName: String, productCategory: String, productImageUrl: String) async -> Result<Void, any Error> {
        let product = Product(context: context)
        product.productid = productId
        product.category = productCategory
        product.image = productImageUrl
        product.productname = productName
        product.date = date
        savedProduct = product
        return .success(())
    }
    
    
}

