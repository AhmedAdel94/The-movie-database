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
    
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {return}
        movieTitle.text = "Title : \(movie.title)"
        movieOverview.text = "OverView : \(movie.overview)"
        movieDate.text = "Release date : \(movie.release_date)"

    }

}
