//
//  MainRouter.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//

import UIKit





class MainRouter : MainRouterProtocol {
    
    weak var view : MainViewController?
    
    func openPokemon(pokemon: RealmModel) {
        let vc = PokemonModuleBuilder.build(pokemon: pokemon)
        view?.present(vc, animated: true)
    }
    
    
    
    

}
