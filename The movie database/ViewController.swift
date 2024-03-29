//
//  ViewController.swift
//  The movie database
//
//  Created by Ahmed Adel on 7/24/19.
//  Copyright © 2019 Ahmed Adel. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,UISearchResultsUpdating {
    
    var movies = [Movie]()
    //var moviesNames = [String]()
    var recentSearch = [Movie]()
    var name = String()
    var page = 1
    
    let threshold = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setupNavbar()
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        name = text
        movies = []
        if text == ""{
            movies = recentSearch
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        
        
        makeUrl(text: text, page: 1)

    }
    
    func makeUrl(text:String , page:Int)
    {
        let urlString : String
        
        urlString = "https://api.themoviedb.org/3/search/movie?api_key=b3070a5d3abfb7c241d2688d066914e7&query=\(text)&page=\(page)"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) // use if let to make sure url is valid
            {
                if let data = try? Data(contentsOf: url){
                    //We are ok to go
                    self.parse(json: data)
                    return
                }
            }
            //self.showError()
        }
    }
    
    func parse(json:Data)
    {
        let decoder = JSONDecoder() // used to convert between JSON and codeable objects
        //print(json)

        if let jsonMovies = try? decoder.decode(Movies.self, from: json){
            movies += jsonMovies.results
            
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
                if self?.movies.count == 0{
                    let AC = UIAlertController(title: "No movie", message: "Can't find this movie , please check the name", preferredStyle: .alert)
                    AC.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(AC,animated: true)
                }else{
//                    self?.recentSearch.append((self?.movies[0])!)
                }
            }
        }
    }
    
    func showError(){
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "Please check your connection and try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac,animated: true)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            let VC = segue.destination as! DetailViewController
            VC.movie = sender as? Movie
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if recentSearch.count < 10{
            self.recentSearch.append(movie)
        }else{
            recentSearch.remove(at: 0)
            self.recentSearch.append(movie)
        }
        performSegue(withIdentifier: "showDetails", sender: movie)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            page += 1
            makeUrl(text: name, page: page)
        }
    }

    
}

