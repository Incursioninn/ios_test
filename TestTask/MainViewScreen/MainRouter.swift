//
//  MainRouter.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//

import UIKit

typealias EntryPoint = AnyMainView & UIViewController

protocol AnyMainRouter {
    
    var entry : EntryPoint? {get}
    static func start () -> AnyMainRouter
    func openPokemon(pokemon : RealmModel)
    
}

class MainRouter : AnyMainRouter {
    var entry : EntryPoint?
    weak var viewController : MainViewController?
    
    static func start() -> AnyMainRouter {
        let router = MainRouter()
        var interactor : AnyMainInteractor = MainInteractor()
        var presenter : AnyMainPresenter = MainPresenter()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "Main") as! MainViewController
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view
        
        return router
    }
    
    func openPokemon(pokemon: RealmModel) {
        let vc = PokemonRouter.build(pokemon: pokemon)
        self.entry?.present(vc, animated: true)
    }
}
