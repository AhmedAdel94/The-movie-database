//
//  DetailViewController.swift
//  The movie database
//
//  Created by Ahmed Adel on 7/24/19.
//  Copyright © 2019 Ahmed Adel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie:Movie?
    
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {return}
        movieTitle.text = "Title : \(movie.title)"
        movieOverview.text = "OverView : \(movie.overview)"
        movieDate.text = "Release date : \(movie.release_date)"
        
        let url = URL(string: "https://image.tmdb.org/t/p/w92/\(movie.poster_path)")!

        downloadImage(from: url)

    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.moviePoster.image = UIImage(data: data)
            }
        }
    }

}
