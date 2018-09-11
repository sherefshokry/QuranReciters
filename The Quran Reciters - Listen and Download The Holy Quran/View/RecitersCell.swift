//
//  RecitersCell.swift
//  The Quran Reciters - Listen and Download The Holy Quran
//
//  Created by SherifShokry on 9/10/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import SDWebImage

class RecitersCell: UICollectionViewCell {
    
    var podcast : Podcast? {
        didSet{
            
           guard let podcast = podcast else { return }
            
            podcastTitle.text = podcast.trackName
            
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
    
    let imageView : UIImageView = {
        var iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "appicon")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        return iv
    }()
    
    let podcastTitle : UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.black
        return label
    }()
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        let stackView = UIStackView(arrangedSubviews: [imageView, podcastTitle])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 0)
        
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
