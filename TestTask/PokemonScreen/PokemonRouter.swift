//
//  MainRouter.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//

import UIKit


protocol AnyPokemonRouter {
    
    static func build (pokemon : RealmModel) -> PokemonViewController
    
}

class PokemonRouter : AnyPokemonRouter {
    
    static func build(pokemon : RealmModel) -> PokemonViewController {
        let router = PokemonRouter()
        
        let interactor = PokemonInteractor()
        let presenter = PokemonPresenter()
        let storyboard = UIStoryboard(name: "PokemonStoryboard", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "PokemonStoryboard") as! PokemonViewController

        
        view.presenter = presenter
        view.pokemon = pokemon
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        return view
    }
}
