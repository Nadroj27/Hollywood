//
//  Movie.swift
//  Hollywood
//
//  Created by Jordan on 21/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import Foundation
import UIKit

struct Movie : Decodable {
    let popularity: Double?
    let voteCount:String?
    let video: Bool?
    let posterPath: Double?
    let id: Int?
    let adult: Bool?
    let backdropPath: String?
    let originalLanguage: String?
    let originalTitle : String?
    let genreIds: [Int]?
    let title : String?
    let voteAverage : Int?
    let overview: String?
    let release_date: String?
}
