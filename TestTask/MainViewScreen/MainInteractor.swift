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
                
                finalPokemon.localSprite = self.saveImage(pokemon: finalPokemon)
                
                DispatchQueue.main.async {
                    try! self.realm.write() {
                        self.realm.add(finalPokemon , update: .all)
                    }
                }
                
                self.presenter?.interactorDidFetchPokemons(with: finalPokemon)
                
            }).resume()
            

            
        }
    }
    
    func saveImage(pokemon : RealmModel) -> String {
        let url = URL(string: pokemon.sprite)
        let pokemonName = pokemon.name
        let data = try! Data(contentsOf: url!)
        let image = UIImage(data: data)
        let fileManager = FileManager.default
        let documentDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentDirectory.appendingPathComponent(pokemonName)
        let imageData = image?.jpegData(compressionQuality: 0.75)
        try! imageData?.write(to: fileURL)
        return "\(fileURL)"
    }

        
    func showFavs() {
        let pokemons = RealmModel.getData()
        let favsIDs = UserDefaults.standard.array(forKey: "Favs") as? [Int] ?? []
        presenter?.didSelectFavs(favs : pokemons.filter {favsIDs.contains($0.id)})
    }
        
    }
    
    
    
    
    
        


