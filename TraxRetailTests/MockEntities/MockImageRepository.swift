//
//  MockImageRepository.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//
@testable import TraxRetail
import UIKit

class MockImageRepository: TraxImageRepository {
    let imageToReturn = UIImage()
    var imageToSave: UIImage? = nil
    func getImage(productId: String) async -> UIImage? {
        imageToReturn
    }
    
    func saveImage(_ image: UIImage, id: String) async -> String? {
        imageToSave = image
        return nil
    }
    
    
}
