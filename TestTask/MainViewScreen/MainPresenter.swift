//
//  MainPresenter.swift
//  TestTask
//
//  Created by iteco on 08.09.2023.
//

import Foundation


class MainPresenter : MainPresenterProtocol {
    var interactor : MainInteractorProtocol?
    weak var view : MainViewProtocol?
    var router : MainRouterProtocol?
    
    init(interactor: MainInteractorProtocol? = nil, view: MainViewProtocol? = nil, router: MainRouterProtocol? = nil) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }
    
}


extension MainPresenter : ViewToPresenterProtocol {

    func showFavs() {
        interactor?.getFavs()
    }

    func fetchPokemons(offset: Int) {
        interactor?.fetchPokemons(offset: offset)
    }

    func didTapPokemon(with pokemon: RealmModel) {
        router?.openPokemon(pokemon: pokemon)
    }


}

extension MainPresenter : InteractorToPresenterProtocol {
    
    func interactorDidFetchPokemons(with result: RealmModel) {
        view?.update(with: result)
    }
    
    func interactorDidFetchPokemons(with result: [RealmModel]) {
        view?.update(with: result)
    }
    
    func setProgressValue(count: Int) {
        view?.setProgressBarOffset(count: count)
    }
    
    func didSelectFavs(favs: [RealmModel]) {
        view?.updateWithFavs(favs: favs)
    }
    
    
}
