//
//  Utilities.swift
//  Hollywood
//
//  Created by Jordan on 21/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL

let BASE_URL = "https://api.themoviedb.org/3/"
let TOP_RATED_MOVIES_URL = "\(BASE_URL)movie/top_rated?api_key=\(API_KEY)"
let SEARCH_MOVIE_URL = "\(BASE_URL)search/movie?api_key=\(API_KEY)&query="
let IMAGE_URL = "https://image.tmdb.org/t/p/w500/"

// KEY

let API_KEY = "516f5c8c4ced7304653d2bc5d0906add"

//GLOBAL

var TOP_MOVIE:Results?
var SEARCH_RESULT:Results?
