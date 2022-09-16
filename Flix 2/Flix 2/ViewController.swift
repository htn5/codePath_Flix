//
//  ViewController.swift
//  Flix 2
//
//  Created by Heather Nguyen on 9/15/22.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
        
        // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                // TODO: Get the array of movies
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.tableView.reloadData()           // calls the tableView functions again
                
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data

            }
        }
        task.resume()
    }
    
    // asking for number of rows, return movies (array) size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // for this particular row, get the cell; gets called for whatever number is returned in above function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reuse cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]           //**** where is the variable indexPath from ****//
        let title = movie["title"] as! String       // casting to string
        let synopsis = movie["overview"] as! String

        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)!
        
        // downloading images from alamo:
            // pod init
            // open Podfile --> add "pod "AlamofireImage""
            // pod install --> close xcode session
            // open . --> open new file created with pods
        cell.posterView.af.setImage(withURL: posterURL)

        // !: swift optionals
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        return cell
    }

}

