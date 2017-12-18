//
//  ViewController.swift
//  Movie Time
//
//  Created by Andrew James Kinsey on 11/29/17.
//  Copyright © 2017 The Cabinents. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var searchTextField: UITextField!
    let apiKey = "ab49369946fca622201b54753bf05125"
    var movieID = String()
    var videoKey = String()
    var canMoveOn = Bool()
    var jsonResults = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func getVideo(videoCode: String)
    {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        myWebView.loadRequest(URLRequest(url: url!))
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any)
    {
        if searchTextField.text == nil || searchTextField.text == ""
        {
            let alert = UIAlertController(title: "No text was entered in the field.", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            getMovieID()
            
            let deadline = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: deadline)
            {
                if self.canMoveOn == true
                {
                self.getVideoCode()

                let deadline = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: deadline)
                    {
                        self.getVideo(videoCode: self.videoKey)
                    }
                }
            }
        }
    }
    
    func getMovieID()
    {
        let textFieldText = searchTextField.text
        let searchedMovie = textFieldText?.replacingOccurrences(of: " ", with: "%20")
        let searchQuery = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchedMovie ?? "Home%20Alone")"

                if let url = URL(string: searchQuery)
                {
                    if let data = try?Data(contentsOf: url)
                    {
                        let json = try?JSON(data: data)
                        self.parseQuery(json: json!)
                        return
                    }
                    else
                    {
                        self.canMoveOn = false
                        let alert = UIAlertController(title: "An ERROR has been encountered.", message: "Try again later.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        
    }
    
    func getVideoCode()
    {
        if canMoveOn == true
        {
        let query = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&append_to_response=videos"
        DispatchQueue.global(qos: .userInitiated).async
            {
                [unowned self] in
                if let url = URL(string: query)
                {
                    if let data = try?Data(contentsOf: url)
                    {
                        let json = try?JSON(data: data)
                        self.parse(json: json!)
                        print(self.movieID)
                        return
                    }
                    else
                    {
                        self.canMoveOn = false
                        let alert = UIAlertController(title: "An ERROR has been encountered.", message: "Try again later.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func parse(json: JSON)
    {
        //let title = json["original_title"]
        let videos = json["videos"]
        let results = videos["results"]
        let movieVideo = results[0]
        let videoCode = movieVideo["key"]
        videoKey = videoCode.stringValue
        print(videoKey)
    }
    
    func parseQuery(json: JSON)
    {
        jsonResults = "\(json["total_results"])"
        print(jsonResults)
        canMoveOn = false
        if jsonResults == "0"
        {
            canMoveOn = false
            let alert = UIAlertController(title: "No movie was found with that title.", message: "Please check the spelling and try again later.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            canMoveOn = true
            for result in json["results"].arrayValue
            {
                let id = result["id"].stringValue
                movieID = id
                return
            }
        }
    }
   
    
    
    

}

