//
//  Model.swift
//  TestTask
//
//  Created by iteco on 31.08.2023.
//
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






