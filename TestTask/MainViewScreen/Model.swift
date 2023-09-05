//
//  Model.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//
import RealmSwift
import Foundation

struct Pokemon : Codable {
    var results : [PokemonEntry]
}

struct PokemonEntry : Codable {
    var name : String
    var url : String
}


struct OnePokemon : Codable {
    var id : Int
    var weight : Int
    var height : Int
    var sprites : PokemonSprites
}

struct PokemonSprites : Codable {
    var front_default : String
}

class RealmModel : Object , Codable {
    
    @objc dynamic var name : String = ""
    @objc dynamic var id : Int = 0
    @objc dynamic var weight : Int = 0
    @objc dynamic var height : Int = 0
    @objc dynamic var sprite : String = ""
    @objc dynamic var localSprite : String = ""
    
    
    init(name: String, id: Int, weight: Int, height: Int, sprite: String , localSprite: String) {
        self.name = name
        self.id = id
        self.weight = weight
        self.height = height
        self.sprite = sprite
        self.localSprite = localSprite
    }
    
    override init() {
        self.name = ""
        self.id = 0
        self.weight = 0
        self.height = 0
        self.sprite = ""
        self.localSprite = ""
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func getData() -> [RealmModel] {
        let model = try! Realm().objects(RealmModel.self)
        return model.dropLast()
        
    }
    

}




