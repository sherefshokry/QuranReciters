//
//  Extenstions.swift
//  AppStore_Demo
//
//  Created by SherifShokry on 7/9/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//
import UIKit
import AVKit

extension UIColor {
    
    static func rgb(red: CGFloat ,green: CGFloat ,blue: CGFloat) -> UIColor{
        
        return  UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        
    }
    
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, topPadding: CGFloat , bottomPadding: CGFloat, leftPadding:CGFloat , rightPadding: CGFloat , width: CGFloat , height: CGFloat)
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top
        {
            topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
      
    }
}
    
extension String {
    
        func toSecureHTTPS() -> String {
            
            return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
        }
        
    }
 
extension CMTime {
    
    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeFormatString
    }
    
}

extension UserDefaults {
    
    static let favouritePodcastKey = "favouritePodcastKey"
    static let downloadsKey = "downloadsKey"
    
    
    
    func downloadEpisode(episode : Episode){
     
        do {
            var downloadedEpisode = downloadedEpisodes()
            downloadedEpisode.insert(episode, at: 0)
            let data = try JSONEncoder().encode(downloadedEpisode)
            set(data, forKey: UserDefaults.downloadsKey)
       
        } catch let encodeErr {
            print("Failed to encode episode : " , encodeErr)
        }
    
    }
    
    func downloadedEpisodes() -> [Episode] {
        
    guard let  data = data(forKey: UserDefaults.downloadsKey) else { return [] }
      
        do {
        
       let downloadedEpisodes = try  JSONDecoder().decode([Episode].self, from: data)
           return downloadedEpisodes
            
        } catch let decodeErr {
             print("Failed to decode episode : " , decodeErr)
        }
        
        return []
    }
    
    func deleteDownloadedEpisode(indexPath : Int){
    
        do {
            var downloadedEpisode = downloadedEpisodes()
            downloadedEpisode.remove(at: indexPath)
            let data = try JSONEncoder().encode(downloadedEpisode)
            set(data, forKey: UserDefaults.downloadsKey)
            
        } catch let encodeErr {
            print("Failed to encode episode : " , encodeErr)
        }
        
        
    }
    
    func fetcDataFromUserDefaults() -> [Podcast] {
        
        guard let savedPodcastsData  = UserDefaults.standard.data(forKey: UserDefaults.favouritePodcastKey)  else { return [] }
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as?  [Podcast] else { return [] }
     
        
        return savedPodcasts
        
    }
    
    
    func deletDataFromUserDefaults(indexPath : Int) {
        
        var listOfPodcasts = [Podcast]()
        listOfPodcasts = fetcDataFromUserDefaults()
        listOfPodcasts.remove(at: indexPath)
        
        let data = NSKeyedArchiver.archivedData(withRootObject : listOfPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favouritePodcastKey)
        
    }
    
}
    
extension UIApplication {
        
       static func mainTapBarController() -> TapBarController {

            return shared.keyWindow?.rootViewController as? TapBarController ?? TapBarController()
            
        }
    }


extension NSNotification {
    
    static let downloadProgress = Name("downloadProgress")

}
    


