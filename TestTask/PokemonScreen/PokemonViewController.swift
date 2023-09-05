//
//  PokemonViewController.swift
//  TestTask
//
//  Created by iteco on 01.09.2023.
//

import UIKit

protocol AnyPokemonView {
    
    var presenter : AnyPokemonPresenter? {get set}
    func updateSwitchOn()
    func updateSwitchOff()
    
}

class PokemonViewController: UIViewController , AnyPokemonView{
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonHeight: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    @IBOutlet weak var addToFavSwitch: UISwitch!
    
    @IBOutlet weak var favLabel: UILabel!
    var pokemon : RealmModel?
    
    var presenter: AnyPokemonPresenter?
    
    let favArray :[Int] = UserDefaults.standard.array(forKey: "Favs") as? [Int] ?? []


    override func viewDidLoad() {
        super.viewDidLoad()
        addToFavSwitch.isEnabled = true
        if favArray.contains(pokemon!.id) {
            addToFavSwitch.setOn(true, animated: true)
        }
        else {
            addToFavSwitch.setOn(false, animated: true)
        }
            
        addToFavSwitch.addTarget(self, action: #selector (onSwitchOn(paramTarget:)), for: .valueChanged)
        pokemonNameLabel.text = pokemon?.name.capitalized
        pokemonHeight.text = "Height: \(pokemon?.height ?? 0)"
        pokemonWeight.text = "Weight: \(pokemon?.weight ?? 0)"
        favLabel.text = "Favourite"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let getImagePath = paths.appendingPathComponent(pokemon!.name)
        let image = UIImage(contentsOfFile: getImagePath)
        self.pokemonImageView.image = image
        

       
    }
    
    @objc func onSwitchOn(paramTarget: UISwitch) {
        if (addToFavSwitch.isOn) {
            presenter?.userDidAddToFav(pokemon: pokemon!)
        }
        else {
            presenter?.userDeletedFromFav(pokemon: pokemon!)
        }
    }
    
    func updateSwitchOn() {
        addToFavSwitch.setOn(true, animated: true)
    }
    
    func updateSwitchOff() {
        addToFavSwitch.setOn(false, animated: true)
    }
    
    
    
    
    


}


