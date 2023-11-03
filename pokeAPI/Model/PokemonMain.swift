//
//  main.swift
//  pokeAPI
//
//  Created by Berkay Yaman on 3.11.2023.
//

import Foundation

// MARK: - Main
struct PokemonMain:  Codable {
    let count: Int?
    let next: String?
    let previous: JSONNull?
    let results: [PokeResult]?
}

// MARK: - Result
struct PokeResult: Codable {
    let name: String?
    let url: String?
}



