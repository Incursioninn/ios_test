//
//  MainInteractor.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//
import RealmSwift
import Foundation



class MainInteractor: MainInteractorProtocol {
    
    weak var presenter : InteractorToPresenterProtocol?
    
    
    func fetchPokemons(offset : Int) {
        guard let url = URL(string : "https://pokeapi.co/api/v2/pokemon?limit=50&offset=\(offset)") else {return}
        URLSession.shared.dataTask(with: url) { (data,response , error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    let pokesFromRealm : [RealmModel] = RealmModel.getData()
                    self.presenter?.interactorDidFetchPokemons(with: pokesFromRealm)
                    
                }
                return
                
            }
            
            let pokemonListInfo = try! JSONDecoder().decode(Pokemon.self, from: data)
            self.presenter?.setProgressValue(count : pokemonListInfo.results.count)
            
            self.collectPokemons(from: pokemonListInfo)
            
        }.resume()
        
        
        
    }
    
    func collectPokemons(from result : Pokemon) {
        for pokemonInfo in result.results {
            guard let url = URL(string: pokemonInfo.url) else {return}
            URLSession.shared.dataTask(with: url , completionHandler :{ (data,response,error) in
                guard let data = data else {return}
                let pokemon = try! JSONDecoder().decode(OnePokemon.self, from: data)
                let isFav = PokemonFavsService.shared.getFavs().contains(pokemon.id)
                let finalPokemon = RealmModel(name: pokemonInfo.name, id: pokemon.id, weight: pokemon.weight , height: pokemon.height, sprite: pokemon.sprites.front_default , localSprite: "" , isFavourite: isFav)
                
                DispatchQueue.main.async {
                    try! RealmModel.realm.write() {
                        RealmModel.realm.add(finalPokemon , update: .all)
                    }
                    self.presenter?.interactorDidFetchPokemons(with: finalPokemon)
                }
                
                
                
            }).resume()
            
            
            
        }
    }
    
    
    func getFavs() {
        let pokemons = RealmModel.getData()
        let favsIDs = PokemonFavsService.shared.getFavs()
        presenter?.didSelectFavs(favs : pokemons.filter {favsIDs.contains($0.id)})
    }
    
}








