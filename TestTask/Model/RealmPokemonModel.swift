//
//  RealmModel.swift
//  TestTask
//
//  Created by iteco on 12.09.2023.
//

import Foundation
import RealmSwift


class RealmModel : Object , Codable {
    
    static let realm = try! Realm()
    
    @objc dynamic var name : String = ""
    @objc dynamic var id : Int = 0
    @objc dynamic var weight : Int = 0
    @objc dynamic var height : Int = 0
    @objc dynamic var sprite : String = ""
    @objc dynamic var localSprite : String = ""
    @objc dynamic var isFavourite : Bool = false
    
    
    init(name: String, id: Int, weight: Int, height: Int, sprite: String , localSprite: String , isFavourite : Bool) {
        self.name = name
        self.id = id
        self.weight = weight
        self.height = height
        self.sprite = sprite
        self.localSprite = localSprite
        self.isFavourite = isFavourite
    }
    
    override init() {
        self.name = ""
        self.id = 0
        self.weight = 0
        self.height = 0
        self.sprite = ""
        self.localSprite = ""
        self.isFavourite = false
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func getData() -> [RealmModel] {
        let model = try! Realm().objects(RealmModel.self)
        return model.dropLast()
        
    }
    

}
