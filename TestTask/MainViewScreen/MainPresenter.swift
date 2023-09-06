//
//  MainPresenter.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//

import UIKit

protocol AnyMainPresenter {
    
    func interactorDidFetchPokemons(with result : RealmModel)
    func interactorDidFetchPokemons(with result : [RealmModel])
    func didSelectFavs (favs : [RealmModel])
    func didTapPokemon (with pokemon : RealmModel)
    func setProgressValue(count : Int)
    var view : AnyMainView? {get set}
    var interactor : AnyMainInteractor? {get set}
    var router : AnyMainRouter? {get set}
    func showFavs()
    func fetchPokemons(offset: Int)
    
}

class MainPresenter : AnyMainPresenter {
    
    var view : AnyMainView?
    var router : AnyMainRouter?
    var interactor : AnyMainInteractor?{
        didSet{
            interactor?.fetchPokemons(offset: 0)
        }
    }
    
    
    func setProgressValue(count: Int) {
        view?.setProgressBarOffset(count : count)
    }
    
    func interactorDidFetchPokemons(with result: RealmModel) {
        view?.update(with: result)
    }
    
    func interactorDidFetchPokemons(with result: [RealmModel]) {
        view?.update(with: result)
    }
    
    func didSelectFavs(favs: [RealmModel]) {
        view?.updateWithFavs(favs: favs)
    }
    
    func didTapPokemon(with pokemon : RealmModel) {
        router?.openPokemon(pokemon: pokemon)
    }
    
    func showFavs() {
        interactor?.showFavs()
    }
    
    func fetchPokemons(offset: Int) {
        interactor?.fetchPokemons(offset: offset)
    }
    
    
    

    
    
    
    
}
