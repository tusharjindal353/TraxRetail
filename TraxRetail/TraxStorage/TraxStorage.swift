//
//  TraxStorage.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 14/04/2025.
//
import CoreData
import Combine

protocol TraxStorage {
    func getProducts() async -> Result<[Product], Error>
    func saveProduct(
        productId: String,
        productName: String,
        productCategory: String,
        productImageUrl: String
    ) async -> Result<Void, Error>
}

class TraxStorageImpl: TraxStorage {
    private let context: NSManagedObjectContext
    private var productSubject = PassthroughSubject<[Product], Error>()
    init(
        context: NSManagedObjectContext
    ) {
        self.context = context
    }
    
    func getProducts() async -> Result<[Product], Error> {
        await self.context.perform {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            do {
                let products = try self.context.fetch(fetchRequest)
                return .success(products)
            } catch {
                return .failure(error)
            }
        }
    }
    
    func saveProduct(
        productId: String,
        productName: String,
        productCategory: String,
        productImageUrl: String
    ) async -> Result<Void, Error> {
        await self.context.perform { [unowned self] in
            let newItem = Product(context: self.context)
            newItem.productname = productName
            newItem.category = productCategory
            newItem.productid = productId
            newItem.date = Date()
            newItem.image = productImageUrl
            
            do {
                try self.context.save()
                return .success(())
            } catch {
                return .failure(error)
            }
        }
    }
}
