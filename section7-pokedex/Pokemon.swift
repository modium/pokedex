//
//  Pokemon.swift
//  section7-pokedex
//
//  Created by Jaf Crisologo on 2016-04-25.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}