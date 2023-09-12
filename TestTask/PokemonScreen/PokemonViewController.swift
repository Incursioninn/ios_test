//
//  PokemonViewController.swift
//  TestTask
//
//  Created by iteco on 01.09.2023.
//

import UIKit



class PokemonViewController: UIViewController , PokemonViewProtocol{
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonHeight: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    @IBOutlet weak var addToFavSwitch: UISwitch!
    @IBOutlet weak var favLabel: UILabel!
    var pokemon : RealmModel?
    
    var presenter: PokemonPresenterProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfo()
        addToFavSwitch.addTarget(self, action: #selector (onSwitchOn(paramTarget:)), for: .valueChanged)
       
    }
    
    @objc func onSwitchOn(paramTarget: UISwitch) {
        if (addToFavSwitch.isOn) {
            presenter?.userDidAddToFav(pokemon: pokemon!)
        }
        else {
            presenter?.userDeletedFromFav(pokemon: pokemon!)
        }
    }
    
    
    
    func setupInfo () {
        pokemonNameLabel.text = pokemon?.name.capitalized
        pokemonHeight.text = "Height: \(pokemon?.height ?? 0)"
        pokemonWeight.text = "Weight: \(pokemon?.weight ?? 0)"
        favLabel.text = "Favourite"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let getImagePath = paths.appendingPathComponent(pokemon!.name)
        let image = UIImage(contentsOfFile: getImagePath)
        self.pokemonImageView.image = image
        pokemon!.isFavourite ? addToFavSwitch.setOn(true, animated: true) : addToFavSwitch.setOn(false, animated: true)
    }

    
    
    
    
    
    


}


