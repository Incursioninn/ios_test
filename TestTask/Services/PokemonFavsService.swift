//
//  PokemonCache.swift
//  TestTask
//
//  Created by iteco on 08.09.2023.
//

import Foundation

class PokemonFavsService {
    
    static let shared = PokemonFavsService()
    
    private var favs : [Int]
    
    private let favsFilePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Favs.plist")
    
    
    private init() {
        if let favsArray = NSArray(contentsOf: favsFilePath) as? [Int] {
            favs = favsArray
        } else {
            favs = [Int]()
        }
    }
    
    func addPokemonToFavs(pokemon : RealmModel) {
        favs.append(pokemon.id)
        try! RealmModel.realm.write {
            pokemon.isFavourite = true
        }
        saveFavs()
    }
    
    func deletePokemonFromFav(pokemon: RealmModel) {
        favs.removeAll { $0 == pokemon.id }
        try! RealmModel.realm.write {
            pokemon.isFavourite = false
        }
        saveFavs()
    }
    
    func getFavs() -> [Int] {
        return favs
    }
    
    private func saveFavs() {
        let favsArray = favs as NSArray
        favsArray.write(to: favsFilePath, atomically: true)
    }
    

}
