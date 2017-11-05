//
//  ViewController.swift
//  section7-pokedex
//
//  Created by Jaf Crisologo on 2016-04-20.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]() //a second array that will be populated by the filtered Pokemon
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self //goes hand in hand with UISearchBarDelegate
        searchBar.returnKeyType = UIReturnKeyType.done
        
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //loop forever
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    func parsePokemonCSV() {
        //take the pokemon.csv file and parse it with csv.swift
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
            print(rows)
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            //make a new Pokemon object every time a cell is created (numberOfItems will make one 718 times)
//            let pokemon = Pokemon(name: "Test", pokedexId: indexPath.row) //1
//            let poke = pokemon[indexPath.row] //2
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.populateCell(poke)
            return cell
            
        } else {
            return UICollectionViewCell() //if cell fails, return a generic UICollectionViewCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //This is where a collectionItem will trigger a new ViewController to appear
        
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count //it needs to know how many item to go through
        } else {
            return pokemon.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 //in the future can categorize among types, egg groups, etc.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //set the size of the grid
        return CGSize(width: 105, height: 105) //you can make this dynamic for say, a photo app with different sized images
    }
    
    @IBAction func MusicBtnPressed(_ sender: UIButton!) {
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true) //if searchBar is empty, force close the keyboard
            collection.reloadData()
        } else {
            inSearchMode = true
            let searchText = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: searchText) != nil}) //if not nil, add push to filteredPokemon
            collection.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}

