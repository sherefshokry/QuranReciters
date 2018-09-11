//
//  EpisodesController.swift
//  Podcasts
//
//  Created by SherifShokry on 9/3/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {

    let cellId = "cellId"
    var episodes = [Episode]()
    var podcast : Podcast? {
        didSet{
            guard let trackName = podcast?.trackName else { return }
            navigationItem.title = trackName
            
            guard let feedURL = podcast?.feedUrl else { return }
               
            fetchEpisodes(feedUrl: feedURL)
        }
    }
    
    func fetchEpisodes(feedUrl : String){
        
        ApiServices.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            
            if(episodes.count == 0){
                let alertController = UIAlertController(title: "Network Connection Error,check internet connection and try again", message: nil, preferredStyle: .actionSheet)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in
            
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                
            }
            self.episodes = episodes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      setupTableView()
      setupFavouriteButton()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(true)
        setupFavouriteButton()
    }

    fileprivate func setupFavouriteButton() {
        
        
        let savedPodcasts = UserDefaults.standard.fetcDataFromUserDefaults()
        var hasFavourited = false
        savedPodcasts.forEach { (podcast) in
            if(podcast.artistName == self.podcast?.artistName && podcast.trackName == self.podcast?.trackName){
                hasFavourited = true
                return
            }
        }
    
        
        if hasFavourited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        }
        else{
            navigationItem.rightBarButtonItem =
                UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(handleFavouriteButton))
        }
        
    }
    
    
    fileprivate func setupTableView(){
        
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
    }
    
   
    @objc func handleFavouriteButton(){
        
        guard let podcast =  podcast else { return }
        
        //1- fetch saved podcasts first
        var listOfPodcasts = [Podcast]()
        listOfPodcasts = UserDefaults.standard.fetcDataFromUserDefaults()
        listOfPodcasts.append(podcast)
     
       //2- transform podcast into data
        let data = NSKeyedArchiver.archivedData(withRootObject : listOfPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favouritePodcastKey)
    
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        
        showBadgeHighlight(index: 0)
    }
   
    func showBadgeHighlight(index : Int){
        let tabBarController =  UIApplication.mainTapBarController()
        tabBarController.viewControllers?[index].tabBarItem.badgeValue = "New"
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let view = UIView()
     
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = UIColor.darkGray
        activityIndicatorView.startAnimating()
      
        let label = UILabel()
        label.text = "Loading, please wait"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        
        
        view.addSubview(activityIndicatorView)
        view.addSubview(label)
        
        activityIndicatorView.anchor(top: view.topAnchor, bottom: nil, left: nil, right: nil, topPadding: 40, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 0)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        label.anchor(top: activityIndicatorView.bottomAnchor, bottom: nil, left: nil, right: nil, topPadding: 10, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 0)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.episodes.count == 0 ? 200 : 0
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return episodes.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let episode = self.episodes[indexPath.row]
        let tabBarController =  UIApplication.mainTapBarController()
        tabBarController.maximizePlayerDetails(epidose: episode)
        
    }

    
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let tableViewRowAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            
          UserDefaults.standard.downloadEpisode(episode: self.episodes[indexPath.row])
        
          ApiServices.shared.downloadEpisode(episode: self.episodes[indexPath.row])
           
        
        }

        return [tableViewRowAction]
    }
    
}
