//
//  MainInteractor.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//
import RealmSwift
import Foundation

protocol AnyMainInteractor {
    
    func fetchPokemons(offset:Int)
    var presenter : AnyMainPresenter? {get set}
    func showFavs()
    
}

class MainInteractor: AnyMainInteractor {
    
    var presenter : AnyMainPresenter?
    
    let realm = try! Realm()
    
    func fetchPokemons(offset : Int) {
        guard let url = URL(string : "https://pokeapi.co/api/v2/pokemon?limit=50&offset=\(offset)") else {return}
        URLSession.shared.dataTask(with: url) { (data,response , error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    let pokesFromRealm : [RealmModel] = RealmModel.getData()
                    self.presenter?.view?.update(with: pokesFromRealm)
                    
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
                
                let finalPokemon = RealmModel(name: pokemonInfo.name, id: pokemon.id, weight: pokemon.weight , height: pokemon.height, sprite: pokemon.sprites.front_default , localSprite: "")
                
                
                DispatchQueue.main.async {
                    try! self.realm.write() {
                        self.realm.add(finalPokemon , update: .all)
                    }
                }
                
                self.presenter?.interactorDidFetchPokemons(with: finalPokemon)
                
            }).resume()
            
            
            
        }
    }
    
    
    func showFavs() {
        let pokemons = RealmModel.getData()
        let favsIDs = UserDefaults.standard.array(forKey: "Favs") as? [Int] ?? []
        presenter?.didSelectFavs(favs : pokemons.filter {favsIDs.contains($0.id)})
    }
    
}








