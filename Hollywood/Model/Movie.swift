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
    let vote_count:Int?
    let video: Bool?
    let poster_path: String?
    let id: Int?
    let adult: Bool?
    let backdrop_path: String?
    let original_language: String?
    let original_title : String?
    let genre_ids: [Int]?
    let title : String?
    let vote_average : Double?
    let overview: String?
    let release_date: String?
}
