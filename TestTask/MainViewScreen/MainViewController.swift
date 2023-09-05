//
//  MainViewController.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//
import UIKit

protocol AnyMainView {
    
    func update (with pokemon : RealmModel)
    func update (with pokemon : [RealmModel])
    func updateWithFavs( favs : [RealmModel])
    func setProgressBarOffset(count : Int)
    var presenter : AnyMainPresenter? {get set}
    
}

class MainViewController: UIViewController , AnyMainView {
    
    
    @IBOutlet weak var favSwitch: UISwitch!
    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var connectionProblemsLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    var tempPokemons : [RealmModel] = []
    var pokemons : [RealmModel] = []
    var filterPokemons : [RealmModel] = []
    var presenter : AnyMainPresenter?
    var progressValue = 0.0
    var progressValueOffset = 0.0

    override func viewDidLoad() {

        super.viewDidLoad()
        pokemonTableView.register(UITableViewCell.self, forCellReuseIdentifier: "pokemonCell")
        favSwitch.setOn(false, animated: true)
        connectionProblemsLabel.isHidden = true
        favSwitch.addTarget(self, action: #selector (showFavs(paramTarget:)), for: .valueChanged)
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    
    
    func update(with pokemons : RealmModel) {
        DispatchQueue.main.async {
            
            self.pokemons.append(pokemons)
            self.tempPokemons.append(pokemons)
            self.pokemonTableView.reloadData()
            self.pokemonTableView.isHidden = false
            self.progressValue += self.progressValueOffset
            self.progressBar.setProgress(Float(self.progressValue), animated: true)
            if self.progressValue >= 1.0 {
                self.progressBar.isHidden = true
            }
        }
        
    }
    
    func update(with pokemons : [RealmModel]) {
        DispatchQueue.main.async {
            self.connectionProblemsLabel.isHidden = false
            self.pokemons = pokemons
            self.tempPokemons = pokemons
            self.pokemonTableView.reloadData()
            self.progressBar.isHidden = true
            self.pokemonTableView.isHidden = false
        }
        
    }
    
    func updateWithFavs (favs : [RealmModel]) {
        self.pokemons = favs
        self.pokemonTableView.reloadData()
    }
    
    @objc func showFavs (paramTarget : UISwitch) {
        if (favSwitch.isOn) {
            presenter?.showFavs()
        }
        else {
            pokemons = tempPokemons
            self.pokemonTableView.reloadData()
        }
        
        
    }
    
    func setProgressBarOffset(count: Int) {
        progressValueOffset = 1.0 / Double(count)
    }
    

}

extension MainViewController : UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let getImagePath = paths.appendingPathComponent(pokemons[indexPath.row].name)
        let image = UIImage(contentsOfFile: getImagePath)
        let cell = pokemonTableView.dequeueReusableCell(withIdentifier: "pokemonCell" , for: indexPath)
        
        
        cell.imageView?.image = image
        cell.textLabel?.text = pokemons[indexPath.row].name.capitalized
        if (indexPath.row + 1 == tempPokemons.count && progressValue >= 1.0) {
            progressValue = 0.0
            progressBar.isHidden = false
            presenter?.fetchPokemons(offset: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapPokemon(with: pokemons[indexPath.row])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterPokemons.removeAll()
        guard !searchText.isEmpty else {
            self.pokemons = tempPokemons
            self.pokemonTableView.reloadData()
            return
        }
        
        for pokemon in tempPokemons {
            let text = searchText.lowercased()
            let isArrayContain = pokemon.name.lowercased().range(of: text)
            
            if isArrayContain != nil {
                filterPokemons.append(pokemon)
            }
            

        }
        self.pokemons = filterPokemons
        self.pokemonTableView.reloadData()
    }
    
    
    
}



