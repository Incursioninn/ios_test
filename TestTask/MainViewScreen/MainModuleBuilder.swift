//
//  ModuleBuilder.swift
//  TestTask
//
//  Created by iteco on 08.09.2023.
//

import Foundation
import UIKit

typealias EntryPoint = MainViewProtocol & UIViewController

class MainModuleBuilder {
    
    static func build() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "Main") as! MainViewController
        let interactor : MainInteractorProtocol = MainInteractor()
        let router : MainRouterProtocol = MainRouter()

        let presenter = MainPresenter(interactor: interactor , view: view , router: router)
        interactor.presenter = presenter
        view.presenter = presenter
        router.view = view

        


        
        return view
    }
    
}
