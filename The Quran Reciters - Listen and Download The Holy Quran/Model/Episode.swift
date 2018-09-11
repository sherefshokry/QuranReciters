//
//  Episode.swift
//  Podcasts
//
//  Created by SherifShokry on 9/3/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import Foundation
import FeedKit

struct Episode : Codable {
 
    let title : String
    let author : String
    let description : String
    let pubDate : Date
    let streamURL : String
    
    var fileURL : String?
    var imageURL : String?
    
    init(feedItem : RSSFeedItem) {
        
       self.title = feedItem.title ?? ""
       self.description = feedItem.description ?? ""
    //    print("Description: ", self.description )
       self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.streamURL = feedItem.enclosure?.attributes?.url ?? "" 
       self.pubDate = feedItem.pubDate ??  Date()
       self.imageURL = feedItem.iTunes?.iTunesImage?.attributes?.href
    
    
    }
    
    
}
