//
//  DownloadsController.swift
//  Podcasts
//
//  Created by SherifShokry on 9/9/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {

    let cellId = "cellId"
    var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupTableView()
        setupObservers()
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
        dissaperBadgeHighlight(index : 2)
    }

    func dissaperBadgeHighlight(index : Int){
        let tabBarController =  UIApplication.mainTapBarController()
        tabBarController.viewControllers?[index].tabBarItem.badgeValue = nil
    }
    
    fileprivate func setupTableView() {
        
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        
    }

    
    fileprivate func setupObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleProgressObserver), name: NSNotification.downloadProgress, object: nil)
        
    }
    
    @objc func handleProgressObserver(notification : Notification){
        
        guard let userInfo =  notification.userInfo as? [String : Any] else { return  }
        guard let title = userInfo["title"] as? String else { return }
        guard let  progress = userInfo["progress"] as? Double else { return }
        
        
        
        
        guard let index = downloadedEpisodes.index(where: { $0.title == title }) else { return }
        
        guard let cell =  tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
        cell.progressLabel.isHidden = false
        cell.isUserInteractionEnabled = false
        cell.progressLabel.text = "\(Int(progress * 100))%"
   
        if progress == 1 {
            cell.progressLabel.isHidden = true
             cell.isUserInteractionEnabled = true
            let tabBarController =  UIApplication.mainTapBarController()
            tabBarController.viewControllers?[2].tabBarItem.badgeValue = "New"
        }
    }
    
    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return downloadedEpisodes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else { return UITableViewCell() }
        cell.episode = self.downloadedEpisodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let tableViewAction = UITableViewRowAction(style: .destructive, title: "Remove") { (_, _) in
        
            
            
            guard let fileUrl = URL(string: self.downloadedEpisodes[indexPath.item].fileURL ?? "") else { return }
            let fileName = fileUrl.lastPathComponent
            
            guard var  trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            trueLocation.appendPathComponent(fileName)
        
            do {
              try  FileManager.default.removeItem(at: trueLocation)
            } catch let err {
                print("Error - could not delete file:", err)
            }
           
            self.downloadedEpisodes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            UserDefaults.standard.deleteDownloadedEpisode(indexPath: indexPath.row)
            
        }
        return [tableViewAction]
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
     let mainTapBarController = UIApplication.mainTapBarController()
        mainTapBarController.maximizePlayerDetails(epidose: downloadedEpisodes[indexPath.item])
        
    }
    
    
    
}
