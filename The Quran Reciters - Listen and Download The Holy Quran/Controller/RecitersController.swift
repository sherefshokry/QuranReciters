//
//  RecitersController.swift
//  Podcasts
//
//  Created by SherifShokry on 9/2/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import Alamofire

class RecitersController : UICollectionViewController , UICollectionViewDelegateFlowLayout  {

    var podcasts = [Podcast]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupCollectionView()
       
       
    
    }
    
   
    
    //MARK:- Setup Work
    
 
    func setupCollectionView() {
        
        collectionView?.backgroundColor = .white
        collectionView?.register(RecitersCell.self, forCellWithReuseIdentifier: cellId)
         fetchReciters()
    
    }
    
    func fetchReciters(){
     
        ApiServices.shared.fetchPodcasts(searchText: "Quran Central") { (searchResult) in
            self.podcasts = searchResult.results
            self.collectionView?.reloadData()
        }
        
    }
    
    
        // MARK: - Table view data source
  
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? RecitersCell else { return UICollectionViewCell() }
        
        cell.podcast = podcasts[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let episodeController = EpisodesController()
        episodeController.podcast = self.podcasts[indexPath.row]
        navigationController?.pushViewController(episodeController, animated: true)
        
    }
    
  

}
