//
//  ViewController.swift
//  Hollywood
//
//  Created by Jordan on 21/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit

class PresentationVC: UIViewController {
    
    @IBOutlet weak var presentationImg: UIImageView!
    @IBOutlet weak var presentationBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        presentationImg.layer.cornerRadius = self.presentationImg.frame.size.width / 2
        presentationImg.clipsToBounds = true
        presentationImg.layer.borderWidth = 3
        presentationImg.layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.1882352941, blue: 0.3294117647, alpha: 1)
        presentationImg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        presentationImg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        presentationImg.layer.shadowOpacity = 1.0
        presentationImg.layer.shadowRadius = 0.0
        
        presentationBtn.layer.cornerRadius = 5
        presentationBtn.layer.borderWidth = 1
        presentationBtn.layer.borderColor = UIColor.white.cgColor
    }
}

