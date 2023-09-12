//
//  MainViewController.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//
import UIKit



class MainViewController: UIViewController , MainViewProtocol {
    
    
    @IBOutlet weak var favSwitch: UISwitch!
    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var connectionProblemsLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    var tempPokemons : [RealmModel] = []
    var pokemons : [RealmModel] = []
    var favPokemons : [RealmModel] = []
    var filterPokemons : [RealmModel] = []
    var presenter : ViewToPresenterProtocol?
    var progressValue = 0.0
    var progressValueOffset = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        presenter?.fetchPokemons(offset: 0)
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
            self.connectionProblemsLabel.isHidden = true
            self.pokemons.append(pokemons)
            self.tempPokemons.append(pokemons)
            let path = IndexPath(row: self.pokemons.count-1, section: 0)
            self.pokemonTableView.beginUpdates()
            self.pokemonTableView.insertRows(at: [path], with: .left)
            self.pokemonTableView.endUpdates()
            self.progressValue += self.progressValueOffset
            self.progressBar.setProgress(Float(self.progressValue), animated: true)
            if self.progressValue >= 1.0 {
                self.progressBar.isHidden = true
            }
        }
        
    }
    
    func update(with pokemons : [RealmModel]) {
            self.progressValue = 1.0
            self.connectionProblemsLabel.isHidden = false
            self.pokemons = pokemons
            self.tempPokemons = pokemons
            self.progressBar.isHidden = true
            self.pokemonTableView.reloadData()
        
    }
    
    func updateWithFavs (favs : [RealmModel]) {
        self.pokemons = favs
        self.favPokemons = favs
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
        let cell = pokemonTableView.dequeueReusableCell(withIdentifier: "pokemonCell" , for: indexPath)
        cell.textLabel?.text = pokemons[indexPath.row].name.capitalized
        let pokeUrl = pokemons[indexPath.row].sprite
        let pokeName = pokemons[indexPath.row].name
        let fileManager = FileManager.default
        let documentDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentDirectory.appendingPathComponent(pokeName)
        if fileManager.fileExists(atPath: fileURL.relativePath) {
            cell.imageView?.image = UIImage(contentsOfFile: fileURL.relativePath)
        }
        else {
            cell.imageView?.downloadAndSavePokemonImage(link: pokeUrl, pokeName: pokeName)
            pokemonTableView.reloadRows(at: [indexPath], with: .none)
        }

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
            let contentYOffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYOffset
            if distanceFromBottom < height {
                if (progressValue >= 1.0) {
                    progressValue = 0.0
                    progressBar.isHidden = false
                    presenter?.fetchPokemons(offset: pokemons.count)
                }
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapPokemon(with: pokemons[indexPath.row])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterPokemons.removeAll()
        guard !searchText.isEmpty else {
            if !favSwitch.isOn {
                self.pokemons = tempPokemons
            }
            else {
                self.pokemons = favPokemons
            }
            self.pokemonTableView.reloadData()
            return
        }
        if favSwitch.isOn {
            for pokemon in favPokemons {
                let text = searchText.lowercased()
                let isArrayContain = pokemon.name.lowercased().range(of: text)
                
                if isArrayContain != nil {
                    filterPokemons.append(pokemon)
                }
                
                
            }
        }
        else {
            for pokemon in tempPokemons {
                let text = searchText.lowercased()
                let isArrayContain = pokemon.name.lowercased().range(of: text)
                
                if isArrayContain != nil {
                    filterPokemons.append(pokemon)
                }
            }
        }

        self.pokemons = filterPokemons
        self.pokemonTableView.reloadData()
    }
    
    
}

extension UIImageView {
    func downloadAndSavePokemonImage(link : String , pokeName : String ) {
        self.image = .add
        guard let url = URL(string: link) else {return}
        URLSession.shared.dataTask(with: url) { (data,response , error) in
            guard let data = data else {return}
            let image = UIImage(data: data)
            let fileManager = FileManager.default
            let documentDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent(pokeName)
            let imageData = image?.pngData()
            try! imageData?.write(to: fileURL)
            DispatchQueue.main.async {
                self.image = UIImage(contentsOfFile: fileURL.relativePath)
            }
        }.resume()
    }
    
}



