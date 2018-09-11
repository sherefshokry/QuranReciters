//
//  ApiServices.swift
//  Podcasts
//
//  Created by SherifShokry on 9/2/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class ApiServices {
    
    //singelton
    static let shared = ApiServices()
    
    func downloadEpisode(episode : Episode) {

        let fileDestination  = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamURL , to: fileDestination).downloadProgress { (progress) in
            
            let name = NSNotification.downloadProgress
            NotificationCenter.default.post(name: name, object: nil, userInfo: ["title" : episode.title , "progress" : progress.fractionCompleted])
         
            }.response { (response) in
                
                if response.error != nil {
                    print("Download Error : " , response.error?.localizedDescription ?? "")
                   
                    return
                }
         
                 var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                
                guard let index  = downloadedEpisodes.index(where: { $0.title == episode.title && $0.author == episode.author}) else { return }
                
            
                do {
                  
                 downloadedEpisodes[index].fileURL = response.destinationURL?.absoluteString ?? ""
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                  UserDefaults.standard.set(data, forKey: UserDefaults.downloadsKey)
                    
                } catch let encodeErr {
                    print("Failed to encode episode : " , encodeErr)
                }
                
                
                
        }
    
    }
    
    
    
    
    func fetchEpisodes(feedUrl : String,completion : @escaping ([Episode]) -> ()){
        
        var episodes = [Episode]()
        guard  let feedURL = URL(string: feedUrl.toSecureHTTPS()) else { return }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: feedURL)
            
            let result = parser.parse()
            
            guard let feed = result.rssFeed, result.isSuccess else {
                print(result.error?.description ?? "")
                completion([])
                return
            }
            
            
            feed.items?.forEach({ (feedItem) in
                
                var episode = Episode(feedItem: feedItem)
                
                if episode.imageURL == nil {
                    episode.imageURL = feed.iTunes?.iTunesImage?.attributes?.href
                }
                
                episodes.append(episode)
            })
            
            completion(episodes)
        }
   
    }
    
    
    func fetchPodcasts(searchText : String, completion : @escaping (_ searchResult : SearchResult) -> ()) {
        
        let url = "https://itunes.apple.com/search"
        
        let parameters = ["term" : searchText , "media" : "podcast"]
       
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err =  dataResponse.error {
                print("Connection Error : " , err)
                return
            }
            
            guard let data =  dataResponse.data else { return }
            
            do{
                let searchResult =  try  JSONDecoder().decode(SearchResult.self, from: data)
     
                completion(searchResult)
           
            }
            catch let decodeError {
                print("Decode Error : ", decodeError)
            }
    
        }
        
    }

}
