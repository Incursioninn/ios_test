//
//  Protocols.swift
//  TestTask
//
//  Created by iteco on 08.09.2023.
//

import Foundation

//MARK: ViewProtocol
protocol MainViewProtocol : AnyObject {
    
    func update (with pokemon : RealmModel)
    func update (with pokemon : [RealmModel])
    func updateWithFavs( favs : [RealmModel])
    func setProgressBarOffset(count : Int)
    var presenter : ViewToPresenterProtocol? {get set}
    
}

//MARK: InteractorProtocol
protocol MainInteractorProtocol : AnyObject {
    
    func fetchPokemons(offset:Int)
    var  presenter : InteractorToPresenterProtocol? {get set}
    func showFavs()
    
}
//MARK: MainRouterProtocol
protocol MainRouterProtocol : AnyObject {
    var view : MainViewController?{get set}
    func openPokemon(pokemon : RealmModel)
    
}

//MARK: MainPresenterProtocol

protocol MainPresenterProtocol {
    var  interactor : MainInteractorProtocol? {get set}
    var  view : MainViewProtocol? {get set}
    var  router : MainRouterProtocol? {get set}
}

//MARK: ViewToPresenterProtocol

protocol ViewToPresenterProtocol {

    func showFavs()
    func fetchPokemons(offset: Int)
    func didTapPokemon(with pokemon : RealmModel)
}

//MARK: InteractorToPresenterProtocol

protocol InteractorToPresenterProtocol : AnyObject {
    
    func interactorDidFetchPokemons(with result : RealmModel)
    func interactorDidFetchPokemons(with result : [RealmModel])
    func didSelectFavs(favs : [RealmModel])
    func setProgressValue(count : Int)
    
}









