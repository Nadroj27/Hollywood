//
//  SearchTableViewCell.swift
//  Hollywood
//
//  Created by Jordan on 22/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieNote: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImg.layer.cornerRadius = 2
        movieImg.layer.borderWidth = 3
        movieImg.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
