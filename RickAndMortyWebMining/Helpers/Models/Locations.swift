//
//  Location.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 5.05.2024.
//

import Foundation

// MARK: - Locations
struct Locations: Codable {
    let info: Info
    let results: [Location]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String?
}

// MARK: - Result
struct Location: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
