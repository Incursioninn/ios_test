//
//  PokemonInteractor.swift
//  TestTask
//
//  Created by iteco on 01.09.2023.
//

import Foundation



class PokemonInteractor : PokemonIneractorProtocol {

    
    weak var presenter: PokemonPresenterProtocol?
    
    func addPokemonToFav(pokemon : RealmModel) {

        PokemonFavsService.shared.addPokemonToFavs(pokemon: pokemon)
    }
    
    func deletePokemonFromFav(pokemon: RealmModel) {
        PokemonFavsService.shared.deletePokemonFromFav(pokemon: pokemon)
    }
    
    
}
