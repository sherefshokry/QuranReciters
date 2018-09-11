//
//  PlayerDetailsView + GesturesHandler.swift
//  The Quran Reciters - Listen and Download The Holy Quran
//
//  Created by SherifShokry on 9/11/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

extension PlayerDetailsView {
    
    //MARK:- Handle PanGesture Recognizer
    
     func addPanGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePlayerTap)))
        minimizeView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        playerDetailsStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    @objc func handleDismissalPan(gesture : UIPanGestureRecognizer){
        
        if gesture.state == .changed {
            let translation =   gesture.translation(in: superview)
            playerDetailsStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        else if gesture.state == .ended {
            let translation =   gesture.translation(in: superview)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut
                , animations: {
                    self.playerDetailsStackView.transform = .identity
                    if translation.y > 50  {
                        
                        let mainTapBar =  UIApplication.mainTapBarController()
                        mainTapBar.minimizePlayerDetails()
                        
                    }
                    
            }, completion: nil)
        }
        
    }

    @objc func  handlePan(gesture : UIPanGestureRecognizer){
        
        if gesture.state == .changed {
            let translation =   gesture.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            self.minimizeView.alpha = 1 + (translation.y / 200)
            
        }
        else if gesture.state == .ended {
            let translation =   gesture.translation(in: self.superview)
            let velocity = gesture.velocity(in: self.superview)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut
                , animations: {
                    self.transform = .identity
                    
                    if translation.y < -200 || velocity.y < -500 {
                        
                        let mainTapBar =  UIApplication.mainTapBarController()
                        mainTapBar.maximizePlayerDetails(epidose: nil)
                        //  gesture.isEnabled = false
                    }else {
                        self.minimizeView.alpha = 1
                    }
                    
            }, completion: nil)
            
        }
    }
    
    //MARK:- Handle AVplayer Audio
    
    func playEpisode(){
        if episode?.fileURL != nil
        {
            playEpisodeUsingFileUrl()
            
        } else {
            guard  let url = URL(string: episode?.streamURL ?? "" ) else { return }
            let playerItem = AVPlayerItem(url: url)
              player.replaceCurrentItem(with: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            
            player.play()
        }
    }
    
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        minimizePlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
    }
    
     func playEpisodeUsingFileUrl(){
        
        guard let fileUrl = URL(string: episode?.fileURL ?? "") else { return }
        let fileName = fileUrl.lastPathComponent
        
        guard var  trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        print("True Location : " , trueLocation.absoluteString )
        trueLocation.appendPathComponent(fileName)
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        
    }
    
     func adjustPlayTime(value: Int64) {
        let fifthteenSeconds = CMTime(value: value, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifthteenSeconds)
        player.seek(to: seekTime)
    }
    
     func addPlayerPlayTimeObserver() {
        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale:
            2), queue: .main) { [weak self] (time) in
                let endTime = self?.player.currentItem?.duration
                let currentSeconds = CMTimeGetSeconds(time)
                let endTimeSeconds = CMTimeGetSeconds(endTime ??
                    CMTime(value: 1, timescale: 1))
                let percentageTime = currentSeconds / endTimeSeconds
                
                self?.playerTimeSlider.value = Float(percentageTime)
                self?.playerTimeLabel.text = time.toDisplayString()
                self?.durationLabel.text = endTime?.toDisplayString()
        }
      
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            
            self?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self?.minimizePlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
    }
    
    
    @objc func handleBackButton() {
        adjustPlayTime(value: -15)
    }
    
    @objc func handleForwardButton() {
        adjustPlayTime(value: 15)
    }
    
    
    @objc func handleMaxVolumeButton() {
        player.volume = 1
        volumeSlider.value = 1
    }
    
    @objc func handleMutedButton() {
        player.volume = 0
        volumeSlider.value = 0
    }
    
    
    @objc func handleVolumeSlider(sender: UISlider) {
        player.volume = sender.value
    }
    
    @objc func handleTimeSlider(){
        
        let percentage = playerTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        
        let durationSeconds = CMTimeGetSeconds(duration)
        let seconds = Float64(percentage) * durationSeconds
        let seekTime = CMTimeMakeWithSeconds(seconds, 1)
        
        player.seek(to: seekTime)
    }
    
    
    
    
    @objc func handleDismissButton(){
        
        let tabBarController =  UIApplication.mainTapBarController()
        tabBarController.playerDetailsView = self
        tabBarController.minimizePlayerDetails()
        
    }
    
    
    @objc func  handlePlayerTap(){
        
        let tabBarController =  UIApplication.mainTapBarController()
        tabBarController.maximizePlayerDetails(epidose: nil)
        
    }
    
    
    @objc func handlePlayPauseButton(){
        
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            minimizePlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            minimizePlayPauseButton.setImage(#imageLiteral(resourceName: "play") ,for: .normal)
        }
    }
    
    
    
    
    
}
