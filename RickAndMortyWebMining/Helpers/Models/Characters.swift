//
//  Characters.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import Foundation

// MARK: - Characters
struct Characters: Codable {
    let info: CharacterInfo
    let results: [Character]
}

// MARK: - Info
struct CharacterInfo: Codable {
    let count, pages: Int
    let next: String
}

struct Character: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct CharacterLocation: Codable {
    let name: String
    let url: String
}
