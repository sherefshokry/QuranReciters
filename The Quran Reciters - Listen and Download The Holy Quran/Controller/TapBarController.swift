//
//  TapBarController.swift
//  Podcasts
//
//  Created by SherifShokry on 9/1/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit

class TapBarController: UITabBarController {
    
    var playerDetailsView = PlayerDetailsView()
    var maximizedTopAnchorConstrain : NSLayoutConstraint!
    var minimizedTopAnchorConstrain : NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.black
        setupViews()
        setupPlayerDetailsView()
        
     }
    
    func  minimizePlayerDetails(){
        
        maximizedTopAnchorConstrain.isActive = false
        minimizedTopAnchorConstrain.isActive = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailsView.minimizeView.alpha = 1
            
        }, completion: nil)
        
        
    }
    
    func  maximizePlayerDetails(epidose : Episode?){
        
        minimizedTopAnchorConstrain.isActive = false
        maximizedTopAnchorConstrain.isActive = true
        maximizedTopAnchorConstrain.constant = 0
      
        
        if epidose != nil {
            playerDetailsView.episode = epidose
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.playerDetailsView.minimizeView.alpha = 0
        }, completion: nil)

    }
    
    //MARK:- Setup Functions
    
    func setupPlayerDetailsView(){
        
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
       
       maximizedTopAnchorConstrain =  playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
         maximizedTopAnchorConstrain.isActive = true
        
        minimizedTopAnchorConstrain =  playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
       playerDetailsView.heightAnchor.constraint(equalToConstant: (view.frame.height )).isActive = true
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    
    func setupViews() {
       
        let favouriteLayout = UICollectionViewFlowLayout()
        let favouriteController = FavouriteController(collectionViewLayout: favouriteLayout)
        let recitersLayout = UICollectionViewFlowLayout()
        let recitersController = RecitersController(collectionViewLayout: recitersLayout)
        
        viewControllers = [
            generateNavController(for: favouriteController, title: "Favourite", image: #imageLiteral(resourceName: "favorites"))
           ,
           generateNavController(for: recitersController, title: "Reciters" , image: #imageLiteral(resourceName: "quran-1"))
            ,
           generateNavController(for: DownloadsController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    

    //MARK:- Helper Functions
    
    
    func generateNavController(for rootViewController : UIViewController , title : String , image : UIImage) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        
        return navController
    }
    
    


}
