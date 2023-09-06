//
//  PokemonInteractor.swift
//  TestTask
//
//  Created by iteco on 01.09.2023.
//

import Foundation

protocol AnyPokemonInteractor {
    var presenter : AnyPokemonPresenter? {get set}
    
    func deletePokemonFromFav(pokemon: RealmModel)
    func addPokemonToFav(pokemon : RealmModel)
}

class PokemonInteractor : AnyPokemonInteractor {

    
    var presenter: AnyPokemonPresenter?
    
    func addPokemonToFav(pokemon : RealmModel) {
        var favs = UserDefaults.standard.array(forKey: "Favs") as? [Int] ?? []
        favs.append(pokemon.id)
        UserDefaults.standard.set(favs, forKey: "Favs")
        
    }
    
    func deletePokemonFromFav(pokemon: RealmModel) {
        let favs = UserDefaults.standard.array(forKey: "Favs") as? [Int] ?? []
        UserDefaults.standard.set(favs.filter{$0 != pokemon.id}, forKey: "Favs")
    }
}
