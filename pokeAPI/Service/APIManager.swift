//
//  APIManager.swift
//  pokeAPI
//
//  Created by Berkay Yaman on 3.11.2023.
//

import Foundation

class APIManager: PokemonService {
    
    func fetchData<T: Codable>(from url: URL, completion: @escaping (Result<T,Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError()))
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemon(pokemonName: String ,completion: @escaping(Result<Pokemon,Error>) -> Void) {
        
        let url =  URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) {
                    completion(.success(pokemon))
                } else {
                    completion(.failure(NSError()))
                }
            }
        }.resume()
    }
}
