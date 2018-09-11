//
//  PodcastCell.swift
//  Podcasts
//
//  Created by SherifShokry on 9/2/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {

    var podcast : Podcast? {
        didSet{
            
         guard let podCast = podcast else { return }
            
          authorName.text  =  podCast.artistName
          trackName.text = podCast.trackName
          episodesCount.text = "\(podCast.trackCount ?? 0) Episodes"
          
            guard  let url = URL(string: podCast.artworkUrl600 ?? "") else { return }
            
 
            
            podcastImageView.sd_setImage(with: url, completed: nil)
 
        }
 
    }
    
    
    let podcastImageView : UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let trackName : UILabel = {
       let label = UILabel()
                label.numberOfLines  = 2
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let authorName : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let episodesCount : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
    
        
        let stackView = UIStackView(arrangedSubviews: [trackName, authorName , episodesCount])
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 3
        
        
        addSubview(podcastImageView)
        addSubview(stackView)
        
        
        
        
        podcastImageView.anchor(top: nil, bottom: nil, left: leadingAnchor, right: nil, topPadding: 0, bottomPadding: 0, leftPadding: 8, rightPadding: 0, width: 100, height: 100)
        podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        stackView.anchor(top: nil, bottom: nil, left: podcastImageView.trailingAnchor, right: trailingAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 8, rightPadding: 0, width: 0, height: 0)
         stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
