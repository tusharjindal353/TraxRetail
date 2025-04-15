//
//  Product+CoreDataProperties.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 14/04/2025.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var category: String?
    @NSManaged public var image: String?
    @NSManaged public var productid: String?
    @NSManaged public var productname: String?
    @NSManaged public var date: Date?

}

extension Product : Identifiable {

}
