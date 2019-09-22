//
//  Result.swift
//  Hollywood
//
//  Created by Jordan on 21/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import Foundation

struct Results: Decodable {
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [Movie]
    }
