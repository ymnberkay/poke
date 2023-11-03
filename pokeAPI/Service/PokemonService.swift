//
//  PokemonService.swift
//  pokeAPI
//
//  Created by Berkay Yaman on 3.11.2023.
//

import Foundation

protocol PokemonService {
    func fetchPokemon(pokemonName: String ,completion: @escaping(Result<Pokemon, Error>) -> Void)
    func fetchData<T: Codable>(from url: URL, completion: @escaping (Result<T,Error>) -> Void)
}
