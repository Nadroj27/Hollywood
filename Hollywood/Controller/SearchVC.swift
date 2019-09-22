//
//  SearchVC.swift
//  Hollywood
//
//  Created by Jordan on 22/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SnapKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        
        self.view.addSubview(searchResultsTableView)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.3294117647, blue: 0.6352941176, alpha: 1)
        searchResultsTableView.isUserInteractionEnabled = true
        searchResultsTableView.isScrollEnabled = true
        searchResultsTableView.alwaysBounceVertical = true
        setupUI()
    }
    
    func setupUI() {
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search a movie..."
        self.navigationItem.searchController = searchController
    }

    //TABLEVIEW
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.view.addSubview(searchResultsTableView)
        searchResultsTableView.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.3294117647, blue: 0.6352941176, alpha: 1)
        searchResultsTableView.isUserInteractionEnabled = true
        searchResultsTableView.isScrollEnabled = true
        searchResultsTableView.alwaysBounceVertical = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive && SEARCH_RESULT!.results.isEmpty) {
            return 0
        } else {
            print(SEARCH_RESULT?.results.count)
            return (SEARCH_RESULT?.results.count ?? 10)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchTableViewCell
            cell!.movieTitle.text = SEARCH_RESULT!.results[indexPath.row].title
            cell!.movieTitle.sizeToFit()
            cell!.movieNote.text = "\(SEARCH_RESULT!.results[indexPath.row].vote_average!)"
            cell?.movieNote.sizeToFit()
            return cell!
        }
        let sell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchTableViewCell
        return sell!
    }
    
    //SEARCHBAR
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != nil else {return}
        //searchResultsTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        //searchResultsTableView.alpha = 1.0
        searchResultsTableView.isUserInteractionEnabled = true
        
        searchResultsTableView.snp.updateConstraints { (make) in
           
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchController.isActive =  true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 2 {
            searchActive = false
            //searchResultsTableView.reloadData()
        } else {
            searchActive = true
            searchMovie { (success) in
                if success {
                    print("succeded request")
                    self.searchResultsTableView.reloadData()
                } else {
                    print(success.description)
                }
            }
            //searchResultsTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        SEARCH_RESULT?.results.removeAll()
        searchResultsTableView.reloadData()
    }
    
    
    func searchMovie(completion: @escaping CompletionHandler) {
        let search = SEARCH_MOVIE_URL + searchBar.text!
        Alamofire.request(search, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    print("JE VAIS LA REQUETTE")
                    let decoder = JSONDecoder()
                    SEARCH_RESULT = try decoder.decode(Results.self, from: data)
                    print(SEARCH_RESULT ?? "non")
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
