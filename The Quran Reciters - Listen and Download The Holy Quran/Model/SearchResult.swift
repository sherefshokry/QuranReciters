//
//  SearchResult.swift
//  Podcasts
//
//  Created by SherifShokry on 9/2/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import Foundation

struct SearchResult : Decodable {
    
    var resultCount : Int
    var results : [Podcast]

    
}
