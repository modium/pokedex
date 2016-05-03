//
//  Pokemon.swift
//  section7-pokedex
//
//  Created by Jaf Crisologo on 2016-04-25.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }

    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string:_pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
//            print(result.value.debugDescription)

            if let dict = result.value as? Dictionary<String, AnyObject> { //convert the JSON to a dictionary
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 { //make sure the Pokemon has a type or else there's 0 types
//                    print(types.debugDescription)
                    if let name = types[0]["name"] {
                        self._type = name
                    }
                    
                    if types.count > 1 {
//                        for var x = 1; x < types.count; x++ {
                        for x in 1 ..< types.count { //new for-loop syntax
                            if let name = types[x]["name"] {
                                self._type! += "/\(name)" //concatenate the secondary type with the first
                            }
                        }
                    }
                } else {
                    self._type = "" //account for no type
                }
                
                print(self._type)
                
//                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
//                    //grab URL and make another request
//                    if let url = descArr[0]["resource_uri"] {
//                        let nsurl = NSURL(string: "\(URL_BASE)\(url)/")!
//                        
//                        Alamofire.request(.GET, nsurl).responseJSON { response in
//                            let desResult = response.result
//                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
//                                if let description = descDict["description"] as? String {
//                                    self._description = description
//                                    print(self._description)
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    self._description = ""
//                }

                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let desResult = response.result
                            
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                            
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed() /* Follow through with request, success or not */
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>]  where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        //exclude Mega Evolutions for now
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                //substring irrelevant characters until you get a number
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to //the name of the Pokemon it becomes
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
//                                print(self._nextEvolutionId)
//                                print(self._nextEvolutionTxt)
//                                print(self._nextEvolutionLvl)
                            }
                        }
                    }
                }
                
            }
        }
    }
}