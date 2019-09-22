//
//  HomeVC.swift
//  Hollywood
//
//  Created by Jordan on 21/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cards

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidAppear(_ animated: Bool) {
        getTopMovies { (success) in
            if success {
                self.homeCollectionView.reloadData()
                print("SUCCESS")
            } else {
                print("ERROR")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }
    
    // COLLECTIONVIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.homeCard.buttonText = "Info"
        
        cell.homeCard.title = TOP_MOVIE?.results[indexPath.row].title ?? ""
        
        let j: Int = TOP_MOVIE?.results[indexPath.row].vote_count ?? 0
        cell.homeCard.itemTitle = "\(String(j)) Stars"
        
        let i: Double = TOP_MOVIE?.results[indexPath.row].vote_average ?? 0.0
        cell.homeCard.itemSubtitle = "\(String(i)) / 10"
        
        if (TOP_MOVIE == nil || TOP_MOVIE?.results[indexPath.row].poster_path == nil) {
            cell.homeCard.backgroundImage = UIImage(named: "justnothing")
        } else {
            let image = URL(string: IMAGE_URL + TOP_MOVIE!.results[indexPath.row].poster_path!)
            let data = try? Data(contentsOf: image!)
            cell.homeCard.backgroundImage = UIImage(data: data!)
        }
        
        if (TOP_MOVIE == nil || TOP_MOVIE?.results[indexPath.row].poster_path == nil) {
            cell.homeCard.icon = UIImage(named: "justnothing")
        } else {
            let image = URL(string: IMAGE_URL + TOP_MOVIE!.results[indexPath.row].backdrop_path!)
            let data = try? Data(contentsOf: image!)
            cell.homeCard.icon = UIImage(data: data!)
        }
        return cell
    }
    
    //REQUEST
    
    func getTopMovies(completion: @escaping CompletionHandler) {
        Alamofire.request(TOP_RATED_MOVIES_URL, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    TOP_MOVIE = try decoder.decode(Results.self, from: data)
                    completion(true)
                } catch {
                    debugPrint(error)
                    completion(false)
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
}
