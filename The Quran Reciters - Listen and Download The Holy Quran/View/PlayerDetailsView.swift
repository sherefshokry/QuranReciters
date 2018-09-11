//
//  PlayerDetailsView.swift
//  Podcasts
//
//  Created by SherifShokry on 9/4/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit


class PlayerDetailsView: UIView {

    var episode : Episode?  {
        didSet{
         
            guard let episode = episode else { return }
         titleLabel.text = episode.title
         minimizeTitleLabel.text = episode.title
        
          playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
          minimizePlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            guard  let url = URL(string: episode.imageURL ?? "" ) else { return }
            
              episodeImageview.sd_setImage(with: url, completed: nil)
              minimizeImageView.sd_setImage(with: url, completed: nil)
           playEpisode()
            
        }
    }
    
    let player : AVPlayer = {
       var player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = true
        return player
    }()
    
    let dismissButton : UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()

    
    let episodeImageview : UIImageView = {
       var iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "appicon")
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: 0.7).isActive = true
        return iv
    }()

    let titleLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()
    
  
    
   let backButton : UIButton = {
    var button = UIButton(type: .system)
     button.setImage(#imageLiteral(resourceName: "rewind15"), for: .normal)
    button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 44).isActive = true
    return button
   }()
   
    let forwardButton : UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        button.addTarget(self, action: #selector(handleForwardButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
 
    let playPauseButton : UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.addTarget(self, action: #selector(handlePlayPauseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    
    let mutedVolumeButton : UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "muted_volume"), for: .normal)
        button.addTarget(self, action: #selector(handleMutedButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 34).isActive = true
        return button
    }()
    
    let maxVolumeButton : UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "max_volume"), for: .normal)
        button.addTarget(self, action: #selector(handleMaxVolumeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 34).isActive = true
        return button
    }()
    
    let volumeSlider : UISlider = {
        var slider = UISlider()
        slider.addTarget(self, action: #selector(handleVolumeSlider(sender:)), for: .valueChanged)
        slider.value = 1
        return slider
    }()
    
    let playerTimeSlider : UISlider = {
        var slider = UISlider()
        slider.addTarget(self, action: #selector(handleTimeSlider), for: .valueChanged)
        slider.value = 0
        return slider
    }()
    
    let playerTimeLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.text = "00:00:00"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()
    
    let durationLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.text = "00:00:00"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()
    
    
   let minimizeView : UIView = {
       var view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let minimizeSeperatorView : UIView = {
       var view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    let minimizeImageView : UIImageView  = {
       var iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "appicon")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        return iv
    }()

    let minimizeTitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Episode Title"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let minimizePlayPauseButton : UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(handlePlayPauseButton), for: .touchUpInside)
        return button
    }()
    
    let minimizedForwardButton : UIButton = {
      var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
          button.addTarget(self, action: #selector(handleForwardButton), for: .touchUpInside)
        return button
    }()
    
    
    
    var playerDetailsStackView : UIStackView = {
        var stackView = UIStackView()
        return stackView
    }()
    
    //MARK:- Handlers & Functions
    
    
   
    
  
    
    override func didMoveToSuperview()  {
        super.didMoveToSuperview()
 
        addPanGestures()
        addPlayerPlayTimeObserver()
    }
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
         backgroundColor = .white
    
        let timeSliderStackView = UIStackView(arrangedSubviews: [UIView(),playerTimeSlider,UIView()])
     
        let timeStackView = UIStackView(arrangedSubviews: [playerTimeLabel,durationLabel])
        timeStackView.distribution = .fillEqually
        
        let playerStackView = UIStackView(arrangedSubviews: [UIView(),backButton,UIView(),playPauseButton,UIView(),forwardButton,UIView()])
        playerStackView.distribution = .equalCentering
        
        
        let volumeStackView = UIStackView(arrangedSubviews: [mutedVolumeButton,volumeSlider,maxVolumeButton])
         volumeStackView.distribution = .fill
        
        
         playerDetailsStackView = UIStackView(arrangedSubviews: [dismissButton,episodeImageview,timeSliderStackView,timeStackView,titleLabel,playerStackView,volumeStackView])
          playerDetailsStackView.axis = .vertical
          playerDetailsStackView.distribution = .fill
          playerDetailsStackView.spacing = 3
        
        addSubview(playerDetailsStackView)
        
        playerDetailsStackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, topPadding: 25, bottomPadding: 30, leftPadding: 25, rightPadding: 25, width: 0, height: 0)
        
       
        let minimizedStackView = UIStackView(arrangedSubviews: [minimizeImageView,minimizeTitleLabel,minimizePlayPauseButton,minimizedForwardButton])
        minimizedStackView.axis = .horizontal
        minimizedStackView.distribution = .fill
        minimizedStackView.spacing = 8
        
        addSubview(minimizeView)
        minimizeView.anchor(top: topAnchor, bottom: nil, left: leadingAnchor, right: trailingAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 64)
        
        minimizeView.addSubview(minimizeSeperatorView)
        minimizeSeperatorView.anchor(top: minimizeView.topAnchor, bottom: nil, left: minimizeView.leadingAnchor, right: minimizeView.trailingAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 0.5)
        
        minimizeView.addSubview(minimizedStackView)
        minimizedStackView.anchor(top: minimizeView.topAnchor, bottom: minimizeView.bottomAnchor, left: minimizeView.leadingAnchor, right: minimizeView.trailingAnchor, topPadding: 8, bottomPadding: 8, leftPadding: 8, rightPadding: 8, width: 0, height: 0)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    
}
