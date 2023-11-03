//
//  PokemonViewModel.swift
//  pokeAPI
//
//  Created by Berkay Yaman on 3.11.2023.
//

import Foundation

class PokemonViewModel {
    
    private let pokemonService: PokemonService
    weak var output: PokemonViewModelOutput?
    
    var pokeName: String = ""
    var pokeID: Int = 0
    var pokeDesc: String = ""
    var pokeWeight: Float = 0.0
    var pokeHeight: Float = 0.0
    var typeArray: [String] = []
    var abilityArray: [String] = []
    var statsDictionary: [String: Int] = [:]
    var image: String = ""
    
    let mainUrl = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    init(pokemonService: PokemonService, output: PokemonViewModelOutput? = nil, pokeName: String, pokeID: Int, pokeDesc: String, pokeWeight: Float, pokeHeight: Float, typeArray: [String], abilityArray: [String], statsDictionary: [String : Int], image: String) {
        self.pokemonService = pokemonService
        self.output = output
        self.pokeName = pokeName
        self.pokeID = pokeID
        self.pokeDesc = pokeDesc
        self.pokeWeight = pokeWeight
        self.pokeHeight = pokeHeight
        self.typeArray = typeArray
        self.abilityArray = abilityArray
        self.statsDictionary = statsDictionary
        self.image = image
    }
    
    func fetchAll() {
        pokemonService.fetchData(from: mainUrl) { [weak self] (result: Result<PokemonMain, Error>) in
            switch result {
                case .success(let pokemonMain):
                    if let results = pokemonMain.results{
                        for result in results {
                            if let urlName = result.url {
                                self?.pokemonService.fetchData(from: URL(string: urlName)!) {[weak self] (result: Result<Pokemon, Error>) in
                                    switch result {
                                        case .success(let pokemon):
                                        self?.pokeName = pokemon.name ?? "Name not found"
                                            self?.pokeID = pokemon.id ?? 0
                                            self?.pokeHeight = Float(pokemon.height ?? 0) / 10
                                            self?.pokeWeight = Float(pokemon.weight ?? 0) / 10
                                            if let types = pokemon.types {
                                                for type in types {
                                                    if let typeName = type.type?.name {
                                                        self?.typeArray.append(typeName)
                                                    }
                                                }
                                            }
                                            if let abilities = pokemon.abilities{
                                                for ability in abilities {
                                                    if let abilityName = ability.ability?.name {
                                                        self?.abilityArray.append(abilityName)
                                                    }
                                                }
                                            }
                                            if let stats = pokemon.stats {
                                                for stat in stats {
                                                    if let statName = stat.stat?.name, let baseStat = stat.baseStat {
                                                        self?.statsDictionary[statName] = baseStat
                                                    }
                                                }
                                            }
                                            if let frontDefault = pokemon.sprites?.other?.officialArtwork?.frontDefault {
                                                self?.image = frontDefault
                                            }
                                        print(self?.statsDictionary)
                                        case .failure(_):
                                            print("Hataa")
                                    }
                                }
                            }
                        }
                    }
                case .failure(_):
                    print("Hataa")
            }
        }
        
        
        //        pokemonService.fetchPokemon(pokemonName:) { [weak self] result in
        //        switch result {
        //        case .success(let pokemon):
        //            self?.pokeName = pokemon.name ?? "Name not found"
        //            self?.pokeID = pokemon.id ?? 0
        //            self?.pokeHeight = Float(pokemon.height ?? 0) / 10
        //            self?.pokeWeight = Float(pokemon.weight ?? 0) / 10
        //            if let types = pokemon.types {
        //                for type in types {
        //                    if let typeName = type.type?.name {
        //                        self?.typeArray.append(typeName)
        //                    }
        //                }
        //            }
        //            if let abilities = pokemon.abilities{
        //                for ability in abilities {
        //                    if let abilityName = ability.ability?.name {
        //                        self?.abilityArray.append(abilityName)
        //                    }
        //                }
        //            }
        //            if let stats = pokemon.stats {
        //                for stat in stats {
        //                    if let statName = stat.stat?.name, let baseStat = stat.baseStat {
        //                        self?.statsDictionary[statName] = baseStat
        //                    }
        //                }
        //            }
        //            if let frontDefault = pokemon.sprites?.other?.officialArtwork?.frontDefault {
        //                self?.image = frontDefault
        //                print(frontDefault)
        //            }
        //
        //            self?.output?.updateView(name: self!.pokeName, id: self!.pokeID, weighy: self!.pokeWeight, height: self!.pokeHeight, types: self!.typeArray, abilities: self!.abilityArray, stats: self!.statsDictionary, image: self!.image)
        //
        //        case .failure(_):
        //            self?.output?.updateView(name: "Hata", id: 111, weighy: 0, height: 0, types: ["Hata"], abilities: ["Hata"], stats: ["String" : 0], image: "Hata")
        //        }
        //    }
    }
}
