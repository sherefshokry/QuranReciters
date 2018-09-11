//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by SherifShokry on 9/3/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import SDWebImage

class EpisodeCell: UITableViewCell {

    var episode : Episode? {
        didSet{
            
           guard let episode = episode else { return }
            
            episodeTitle.text  =  episode.title
     
            guard  let url = URL(string: episode.imageURL ?? "" ) else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
       
        }
    }
    
    let progressLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    
    let episodeImageView : UIImageView =  {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    let episodeTitle : UILabel = {
        let label = UILabel()
        label.numberOfLines  = 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
 
    

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        
        episodeImageView.addSubview(progressLabel)
        progressLabel.anchor(top: episodeImageView.topAnchor, bottom: episodeImageView.bottomAnchor, left: episodeImageView.leadingAnchor, right: episodeImageView.trailingAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 0)
        
        
       
        
    
        addSubview(episodeImageView)
        episodeImageView.anchor(top: nil, bottom: nil, left: leadingAnchor, right: nil, topPadding: 0, bottomPadding: 0, leftPadding: 8, rightPadding: 0, width: 100, height: 100)
        episodeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        addSubview(episodeTitle)
        
        episodeTitle.anchor(top: nil, bottom: nil, left: episodeImageView.trailingAnchor, right: trailingAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 8, rightPadding: 0, width: 0, height: 0)
        episodeTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
