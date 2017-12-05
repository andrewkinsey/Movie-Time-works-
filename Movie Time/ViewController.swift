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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVideo(videoCode: "pPEfojnodKY")
        
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
        }
        else
        {
            getMovieID()
            let query = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&append_to_response=videos"
            DispatchQueue.global(qos: .userInitiated).async
                {
                    [unowned self] in
                    if let url = URL(string: query)
                    {
                        if let data = try?Data(contentsOf: url)
                        {
                            let json = try?JSON(data: data)
                            
                        }
                        else
                        {
                            //solve error
                        }
                    }
            }
        }
        
    }
    
    func getMovieID()
    {
        let searchedMovie = searchTextField.text
        let searchQuery = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchedMovie ?? apiKey)"
        DispatchQueue.global(qos: .userInitiated).async
            {
                [unowned self] in
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
                        //solve error
                    }
                }
        }
    }
    
    func parse(json: JSON)
    {
        
    }
    
    func parseQuery(json: JSON)
    {
        for result in json["results"].arrayValue
        {
            let id = result["id"].stringValue
            movieID = id
            return
        }
    }
    

}

