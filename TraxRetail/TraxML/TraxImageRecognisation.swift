//
//  TraxImageRecognisation.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//
import UIKit
import CoreML
import Vision
import Combine

enum TraxImageRecognisationError: Error {
    case failedToLoadModel
    case classificationFailed
    case imageConversionFailed
    case resultParsingFailed
}

protocol TraxImageRecognisation {
    func recogniseImage(image: UIImage) async -> Result<String, Error>
}

class TraxImageRecognisationImpl: TraxImageRecognisation {
    func recogniseImage(image: UIImage) async -> Result<String, Error> {
        do {
            guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
                return .failure(TraxImageRecognisationError.failedToLoadModel)
            }

            guard let ciImage = CIImage(image: image) else {
                return .failure(TraxImageRecognisationError.imageConversionFailed)
            }

            return try await withCheckedThrowingContinuation { continuation in
                let request = VNCoreMLRequest(model: model) { request, error in
                    if let error = error {
                        continuation.resume(returning: .failure(error))
                        return
                    }

                    guard let results = request.results as? [VNClassificationObservation] else {
                        continuation.resume(returning: .failure(TraxImageRecognisationError.resultParsingFailed))
                        return
                    }

                    let stringResult = results.map {
                        "\($0.identifier) \((($0.confidence * 100).rounded()))%"
                    }.joined(separator: "\n")

                    continuation.resume(returning: .success(stringResult))
                }

                let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(returning: .failure(error))
                }
            }
        } catch {
            return .failure(error)
        }
    }

}
