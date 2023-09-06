//
//  PokemonPresenter.swift
//  TestTask
//
//  Created by iteco on 01.09.2023.
//

import Foundation

protocol AnyPokemonPresenter {
    
    var view: AnyPokemonView? {get set}
    var interactor : AnyPokemonInteractor? {get set}
    var router : AnyPokemonRouter? {get set}
    
    func userDidAddToFav(pokemon : RealmModel)
    func userDeletedFromFav(pokemon : RealmModel)
    
    
}

class PokemonPresenter : AnyPokemonPresenter {

    
    
    
    var view : AnyPokemonView?
    var interactor : AnyPokemonInteractor?
    var router: AnyPokemonRouter?
    
    
    
    
    
    func userDeletedFromFav(pokemon: RealmModel) {
        interactor?.deletePokemonFromFav(pokemon: pokemon)
    }
    
    
    func userDidAddToFav(pokemon : RealmModel) {
        interactor?.addPokemonToFav(pokemon :pokemon)
    }
    
    
    
}
