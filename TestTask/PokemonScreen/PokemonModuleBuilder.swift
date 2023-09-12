//
//  ModuleBuilder.swift
//  TestTask
//
//  Created by iteco on 08.09.2023.
//

import Foundation
import UIKit


class PokemonModuleBuilder {
    
    static func build(pokemon : RealmModel) -> PokemonViewController {

        let router : PokemonRouterProtocol = PokemonRouter()
        let interactor : PokemonIneractorProtocol = PokemonInteractor()
        let presenter : PokemonPresenterProtocol = PokemonPresenter()
        
        let storyboard = UIStoryboard(name: "PokemonStoryboard", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "PokemonStoryboard") as! PokemonViewController
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        view.pokemon = pokemon
        
        
        return view
    }
    
}
