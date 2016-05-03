//
//  Constants.swift
//  section7-pokedex
//
//  Created by Jaf Crisologo on 2016-04-30.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import Foundation

//values that are globally accessible because they aren't contained in a class
let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> () //empty closure without parameters that returns nothing
