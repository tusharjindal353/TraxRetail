//
//  TraxImageRepository.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//

import UIKit

enum ImageSaveError: Error {
    case failedToConvertImage
    case failedToWriteFile
}

protocol TraxImageRepository {
    func getImage(productId: String) async -> UIImage?
    func saveImage(_ image: UIImage, id: String) async -> String?
}

class TraxImageRepositoryImpl: TraxImageRepository {
    var cache = NSCache<NSString, UIImage>()
    
    func getImage(productId: String) async -> UIImage? {
        if let image = cache.object(forKey: productId as NSString) {
            return image
        }
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async { [unowned self] in
                let url = self.getDocumentsDirectory().appendingPathComponent(productId)
                let image = UIImage(contentsOfFile: url.path)
                if let image = image {
                    cache.setObject(image, forKey: productId as NSString)
                }
                continuation.resume(returning: image)
            }
        }
    }
    
    func saveImage(_ image: UIImage, id: String) async -> String? {
        let task = Task.detached { [unowned self] in
            guard let data = image.jpegData(compressionQuality: 1.0) else {
                throw ImageSaveError.failedToConvertImage
            }
            let url = self.getDocumentsDirectory().appendingPathComponent(id)
            do {
                try data.write(to: url)
                return url.absoluteString
            } catch {
                throw ImageSaveError.failedToWriteFile
            }
        }
        return try? await task.value
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
