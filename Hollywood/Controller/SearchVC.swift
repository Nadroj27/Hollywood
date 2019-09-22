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
    private lazy var searchResultsTableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive: Bool = false
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),
                                                        type: .ballClipRotate,
                                                        color: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        searchResultsTableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight) //CGRect(0, 0, screenWidth, screenHeight)
        searchResultsTableView.register(UINib.init(nibName: "FriendSearchResultCell", bundle: nil), forCellReuseIdentifier: "FriendSearchResultCell")
        
        
        self.view.addSubview(searchResultsTableView)
        searchResultsTableView.alpha = 0.0
        searchResultsTableView.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.1568627451, blue: 0.2392156863, alpha: 1)
        searchResultsTableView.isUserInteractionEnabled = false
        searchResultsTableView.isScrollEnabled = true
        searchResultsTableView.alwaysBounceVertical = true
        setupUI()
    }
    
    func setupUI() {
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search a movie..."
        self.navigationItem.searchController = searchController
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
        self.activityIndicatorView.startAnimating()
    }

    //TABLEVIEW
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultsTableView.register(UINib.init(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        
        self.view.addSubview(searchResultsTableView)
        searchResultsTableView.alpha = 0.0
        searchResultsTableView.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.3294117647, blue: 0.6352941176, alpha: 1)
        searchResultsTableView.isUserInteractionEnabled = false
        searchResultsTableView.isScrollEnabled = true
        searchResultsTableView.alwaysBounceVertical = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(2)
        print("dodo")
        self.activityIndicatorView.stopAnimating()
        searchResultsTableView.reloadData()
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
            let b:Int = SEARCH_RESULT!.results[indexPath.row].voteAverage ?? 0
            cell!.movieNote.text = String(b)
            return cell!
        }
        let sell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchTableViewCell
        return sell!
    }
    
    //SEARCHBAR
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != nil else {return}
        searchResultsTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchResultsTableView.alpha = 1.0
        searchResultsTableView.isUserInteractionEnabled = true
        
        searchResultsTableView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.bottomAnchor as! ConstraintRelatableTarget)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.bottomAnchor as! ConstraintRelatableTarget)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchController.isActive =  true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 2 {
            searchActive = false
            searchResultsTableView.reloadData()
        } else {
            searchActive = true
            searchMovie { (success) in
                if success {
                    print("succeded request")
                } else {
                    print(success.description)
                }
            }
            searchResultsTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        //SEARCH_RESULT.removeAll()
        searchResultsTableView.reloadData()
        searchResultsTableView.alpha = 0.0
    }
    
    
    func searchMovie(completion: @escaping CompletionHandler) {
        let search = SEARCH_MOVIE_URL + searchBar.text!
        
        Alamofire.request(search, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
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
