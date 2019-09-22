//
//  SearchVC.swift
//  Hollywood
//
//  Created by Jordan on 22/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchController.searchBar.placeholder = "Search a movie..."
        searchResultsTableView.alpha = 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive && SEARCH_RESULT!.results.isEmpty) {
            return 0
        } else {
            return (SEARCH_RESULT?.results.count ?? 10)
        }
    }
    
    // TABLEVIEW
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailMovieVC") as! DetailMovieVC
        vc.titre = SEARCH_RESULT!.results[indexPath.row].title!
        vc.origin = SEARCH_RESULT!.results[indexPath.row].original_language!
        vc.release = SEARCH_RESULT!.results[indexPath.row].release_date!
        vc.resume = SEARCH_RESULT!.results[indexPath.row].overview!
        
        if (SEARCH_RESULT!.results[indexPath.row].poster_path == nil) {
            vc.image = UIImage(named: "justnothing")!
        } else {
            let image = URL(string: IMAGE_URL + SEARCH_RESULT!.results[indexPath.row].poster_path!)
            let data = try? Data(contentsOf: image!)
            vc.image = UIImage(data: data!)!
        }
        
        self.present(vc, animated: true , completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchTableViewCell
            cell!.movieTitle.text = SEARCH_RESULT!.results[indexPath.row].title
            cell!.movieTitle.sizeToFit()
            cell!.movieNote.text = "\(SEARCH_RESULT!.results[indexPath.row].vote_average!) / 10"
            cell!.movieNote.sizeToFit()
            
            if (SEARCH_RESULT!.results[indexPath.row].poster_path == nil) {
                cell!.movieImg.image = UIImage(named: "justnothing")
            } else {
                let image = URL(string: IMAGE_URL + SEARCH_RESULT!.results[indexPath.row].poster_path!)
                let data = try? Data(contentsOf: image!)
                cell!.movieImg.image = UIImage(data: data!)
            }
            return cell!
        }
        let sell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchTableViewCell
        return sell!
    }
    
    // SEARCHBAR
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != nil else {return}
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchResultsTableView.isUserInteractionEnabled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchController.isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 2 {
            searchActive = false
            searchResultsTableView.alpha = 0
            searchResultsTableView.reloadData()
            
        } else {
            searchActive = true
            searchResultsTableView.alpha = 1
            searchMovie { (success) in
                if success {
                    print("succeded request")
                    self.searchResultsTableView.reloadData()
                } else {
                    print(success.description)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        SEARCH_RESULT?.results.removeAll()
        searchResultsTableView.alpha = 0
        searchResultsTableView.reloadData()
    }
    
    // REQUEST
    
    func searchMovie(completion: @escaping CompletionHandler) {
        let search = SEARCH_MOVIE_URL + searchBar.text!
        Alamofire.request(search, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    SEARCH_RESULT = try decoder.decode(Results.self, from: data)
                    DispatchQueue.main.async {
                    self.searchResultsTableView.reloadData()
                    }
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
