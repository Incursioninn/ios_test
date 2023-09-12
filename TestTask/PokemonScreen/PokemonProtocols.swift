//
//  Protocolds.swift
//  TestTask
//
//  Created by iteco on 08.09.2023.
//

import Foundation


protocol PokemonViewProtocol: AnyObject {
    
    var presenter : PokemonPresenterProtocol? {get set}
    
}


protocol PokemonRouterProtocol : AnyObject {
    
   // static func build (pokemon : RealmModel) -> PokemonViewController
    
}

protocol PokemonIneractorProtocol : AnyObject {
    var presenter : PokemonPresenterProtocol? {get set}
    
    func deletePokemonFromFav(pokemon: RealmModel)
    func addPokemonToFav(pokemon : RealmModel)
}


protocol PokemonPresenterProtocol : AnyObject {
    
    var view: PokemonViewProtocol? {get set}
    var interactor : PokemonIneractorProtocol? {get set}
    var router : PokemonRouterProtocol? {get set}
    
    func userDidAddToFav(pokemon : RealmModel)
    func userDeletedFromFav(pokemon : RealmModel)
    
    
}
