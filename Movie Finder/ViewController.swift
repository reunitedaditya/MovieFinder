//
//  ViewController.swift
//  Movie Finder
//
//  Created by united on 25/02/17.
//  Copyright © 2017 united. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var movieSearchTextField: UITextField!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieActor: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieRated: UILabel!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieName.isHidden = true
        self.movieActor.isHidden = true
        self.movieDirector.isHidden = true
        self.movieReleaseDate.isHidden = true
        self.movieRated.isHidden = true
        
        initilizeGestures()
        
       
       
    }
    
    @IBAction func searchMovie(_ sender: Any) {   //Main search Function
        
     
        if movieSearchTextField.text != nil {
            
            let movieName = movieSearchTextField.text?.replacingOccurrences(of: " ", with: "+")
            
            Alamofire.request("http://www.omdbapi.com/?t=\(movieName!)&y=&plot=short&r=json").responseJSON { response in
             
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    
                    let response = JSON as! NSDictionary
                    
                     let serverResponse = response.object(forKey: "Response") as? String
                    
                    if serverResponse == "False" {
                        
                      let alert = UIAlertController(title: "Movie Not Found", message: "make sure the name is correct", preferredStyle: .alert)
                        
                      let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                        
                        alert.addAction(alertAction)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        self.movieName.isHidden = false
                        self.movieActor.isHidden = false
                        self.movieDirector.isHidden = false
                        self.movieReleaseDate.isHidden = false
                        self.movieRated.isHidden = false
                        
                        var myMovie = Movie()
                        
                        myMovie.actors = response.object(forKey: "Actors")! as? String
                        myMovie.poster = response.object(forKey: "Poster")! as? String
                        myMovie.title = response.object(forKey: "Title") as? String
                        myMovie.director = response.object(forKey: "Director") as? String
                        myMovie.released = response.object(forKey: "Released") as? String
                        myMovie.rated = response.object(forKey: "Rated") as? String
                        
                        self.posterImageView.sd_setImage(with: URL(string: myMovie.poster!), placeholderImage: #imageLiteral(resourceName: "loader"), options: [.continueInBackground , .progressiveDownload])
                        
                        self.movieName.text = "Title : \(myMovie.title!)"
                        self.movieActor.text = "Actors : \(myMovie.actors!)"
                        self.movieDirector.text = "Director : \(myMovie.director!)"
                        self.movieReleaseDate.text = "Released : \(myMovie.released!)"
                        self.movieRated.text = "Rated : \(myMovie.rated!)"
              
                    }
     
                }
            }
        }
        
    }
    
    
 
    func initilizeGestures(){   //Handling Keyboard
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTop))
        
        self.view.addGestureRecognizer(tap)
        
        
    }
    
    func handleTop(sender : UITapGestureRecognizer) {
        
        view.endEditing(true)
        
    }

}

