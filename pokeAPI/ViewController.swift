//
//  ViewController.swift
//  pokeAPI
//
//  Created by Berkay Yaman on 3.11.2023.
//

import UIKit

class ViewController: UIViewController {
    //    private let viewModel: PokemonViewModel
    var api = APIManager()
    var statsDictionary: [String: Int] = [:]
    var typeArray: [String] = []
    var abilityArray: [String] = []
    let detailURL = URL(string: "https://pokeapi.co/api/v2/pokemon/1")!
    let mainUrl = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    //    init(viewModel: PokemonViewModel, statsDictionary: [String : Int], typeArray: [String], abilityArray: [String]) {
    //        self.viewModel = viewModel
    //        self.statsDictionary = statsDictionary
    //        self.typeArray = typeArray
    //        self.abilityArray = abilityArray
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewModel.fetchAll()
        api.fetchData(from: detailURL) { (result: Result<Pokemon, Error>) in
            switch result {
            case .success(let pokemon):
                print(pokemon.id ?? "ID not found")
                print(pokemon.name ?? "Name not found")
                print(Float(pokemon.weight ?? 0) / 10)
                print(Float(pokemon.height ?? 0) / 10)
                if let types = pokemon.types {
                    for type in types {
                        if let typeName = type.type?.name {
                            self.typeArray.append(typeName)
                        }
                    }
                }
                if let abilities = pokemon.abilities{
                    for ability in abilities {
                        if let abilityName = ability.ability?.name {
                            self.abilityArray.append(abilityName)
                        }
                    }
                }
                
                if let stats = pokemon.stats {
                    for stat in stats {
                        if let statName = stat.stat?.name, let baseStat = stat.baseStat {
                            self.statsDictionary[statName] = baseStat
                        }
                    }
                }
                print(self.typeArray)
                print(self.abilityArray)
                print(self.statsDictionary)
                if let frontDefault = pokemon.sprites?.other?.officialArtwork?.frontDefault {
                    print(frontDefault)
                }
                
            case .failure(_):
                print("Hataa")
            }
        }
        
        api.fetchData(from: mainUrl) { (result: Result<PokemonMain, Error>) in
            switch result {
            case .success(let pokemonMain):
                if let results = pokemonMain.results{
                    for result in results {
                        if let resultName = result.name, let urlName = result.url {
                            print(resultName)
                            print(urlName)
                            self.api.fetchData(from: URL(string: urlName)!) { (result: Result<Pokemon, Error>) in
                                switch result {
                                case .success(let pokemon):
                                    if let types = pokemon.types {
                                        for type in types {
                                            if let typeName = type.type?.name {
                                                self.typeArray.append(typeName)
                                            }
                                        }
                                    }
                                    if let abilities = pokemon.abilities{
                                        for ability in abilities {
                                            if let abilityName = ability.ability?.name {
                                                self.abilityArray.append(abilityName)
                                            }
                                        }
                                    }
                                    if let stats = pokemon.stats {
                                        for stat in stats {
                                            if let statName = stat.stat?.name, let baseStat = stat.baseStat {
                                                self.statsDictionary[statName] = baseStat
                                            }
                                        }
                                    }
                                    
                                print(self.statsDictionary)
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
    }
}



