//
//  FavouriteController.swift
//  Podcasts
//
//  Created by SherifShokry on 9/8/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit


class FavouriteController: UICollectionViewController , UICollectionViewDelegateFlowLayout {

   var listOfPodcasts = [Podcast]()
   let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        fetchFavourites()
       
    }

 
    
    fileprivate func  setupCollectionView(){
      
        collectionView?.backgroundColor = UIColor.white
        // Register cell classes
        self.collectionView!.register(RecitersCell.self, forCellWithReuseIdentifier: cellId)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(gesture)

    }

    @objc func handleLongPress(gesture : UILongPressGestureRecognizer){
    let location = gesture.location(in: collectionView)
    guard  let selectedIndexPath =  collectionView?.indexPathForItem(at: location) else { return }
    
    let alertController = UIAlertController(title: "remove it ?", message: nil, preferredStyle: .actionSheet)
      
    alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            
            self.listOfPodcasts.remove(at: selectedIndexPath.item)
            self.collectionView?.deleteItems(at: [selectedIndexPath])
            UserDefaults.standard.deletDataFromUserDefaults(indexPath: selectedIndexPath.item)
        }))
   
    alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
      
        present(alertController, animated: true, completion: nil)
     
    }
    
    
    func   fetchFavourites(){
        
        guard let data  = UserDefaults.standard.data(forKey: UserDefaults.favouritePodcastKey)  else { return }
        
        guard let listOfPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as?  [Podcast] else { return }
        
        self.listOfPodcasts = listOfPodcasts
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
          fetchFavourites()
          dissaperBadgeHighlight(index : 0)
    }
    
    func dissaperBadgeHighlight(index : Int){
        let tapBarController = UIApplication.mainTapBarController()
        tapBarController.viewControllers?[index].tabBarItem.badgeValue = nil
    }
    
    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listOfPodcasts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? RecitersCell else { return UICollectionViewCell() }
      
       cell.podcast = listOfPodcasts[indexPath.row]
        
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
        episodeController.podcast = self.listOfPodcasts[indexPath.row]
        navigationController?.pushViewController(episodeController, animated: true)
        
        
    }
    
    
   /* override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No result, please enter a search query."
        label.textColor = UIColor.purple
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }
 */
    
}
