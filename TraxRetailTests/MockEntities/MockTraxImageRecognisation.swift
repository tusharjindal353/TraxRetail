//
//  MockTraxImageRecognisation.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 15/04/2025.
//
@testable import TraxRetail
import UIKit

class MockTraxImageRecognisation: TraxImageRecognisation {
    var resultToReturn: Result<String, Error>!
    func recogniseImage(image: UIImage) async -> Result<String, Error> {
        resultToReturn
    }
}
