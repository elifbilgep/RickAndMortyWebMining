//
//  APIError.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import Foundation

enum APIError: Error {
    case requestFailed(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonConversionFailure(description: String)
    case jsonParsingFailure
    case noInternet
    
    var customDescription: String {
        switch self {
        case .requestFailed(let description):
            return "Request failed: \(description)"
        case .invalidData:
            return "Invalid data"
        case .responseUnsuccessful(let description):
            return "Unsuccessful: \(description)"
        case .jsonConversionFailure(let description):
            return "JSON ConversionFailure: \(description)"
        case .jsonParsingFailure:
            return "JSON Parser Failure"
        case .noInternet:
            return "No Internet connection"
        }
    }
}
