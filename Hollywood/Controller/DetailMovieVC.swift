//
//  DetailMovieVC.swift
//  Hollywood
//
//  Created by Jordan on 22/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit

class DetailMovieVC: UIViewController {

    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieOrigin: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRelease: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    
    var titre: String! = ""
    var release: String! = ""
    var origin: String! = ""
    var resume: String! = ""
    var image: UIImage! = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        movieTitle.text = titre
        movieTitle.sizeToFit()
        movieRelease.text = release
        movieRelease.sizeToFit()
        movieOrigin.text = origin
        movieOrigin.sizeToFit()
        movieDescription.text = resume
        movieImg.image = image
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
