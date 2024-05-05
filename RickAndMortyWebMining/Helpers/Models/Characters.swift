//
//  Characters.swift
//  RickAndMortyWebMining
//
//  Created by Elif Parlak on 7.04.2024.
//

import Foundation

struct Characters: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name:  String
    let status: String
    let species: String
    let gender: String
    let image: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case status
        case species
        case gender
        case image
    }
}
