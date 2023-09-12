//
//  PokemonPresenter.swift
//  TestTask
//
//  Created by iteco on 01.09.2023.
//

import Foundation



class PokemonPresenter : PokemonPresenterProtocol {

    
    
    
    weak var view : PokemonViewProtocol?
    var interactor : PokemonIneractorProtocol?
    var router: PokemonRouterProtocol?
    
    
    
    
    
    func userDeletedFromFav(pokemon: RealmModel) {
        interactor?.deletePokemonFromFav(pokemon: pokemon)
    }
    
    
    func userDidAddToFav(pokemon : RealmModel) {
        interactor?.addPokemonToFav(pokemon :pokemon)
    }
    
    
    
    
}
