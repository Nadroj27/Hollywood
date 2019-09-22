//
//  Result.swift
//  Hollywood
//
//  Created by Jordan on 21/09/2019.
//  Copyright © 2019 Jordan. All rights reserved.
//

import Foundation
import UIKit

struct Results: Decodable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]
}
