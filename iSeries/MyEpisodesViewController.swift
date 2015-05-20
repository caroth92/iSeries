//
//  MyEpisodesViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/22/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class MyEpisodesViewController: PFQueryTableViewController {
    
    var serie: PFObject!
    var userEpisodes: NSMutableDictionary = NSMutableDictionary()
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Episodio"
        self.textKey = "Titulo"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Episodes"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Parse table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Temporada")
        query.whereKey("serie", equalTo: self.serie)
        query.includeKey("serie")
        
        var episodes = PFQuery(className: "Episodio")
        episodes.whereKey("temporada", matchesKey: "objectId", inQuery: query)
        
        return episodes
    }
    
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)
        
        // Add episode's seen state
        for object in self.objects! {
            var query = PFQuery(className: "UserHistorial")
            query.whereKey("episodio", equalTo: object)
            query.whereKey("user", equalTo: PFUser.currentUser()!)
            query.getFirstObjectInBackgroundWithBlock{
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil && object != nil {
                    let episode = object!["episodio"] as? PFObject
                    self.userEpisodes[episode!.objectId!] = object
                }
            }
        }
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PFTableViewCell
        
        if let title = object?["Titulo"] as? String {
            cell.textLabel!.text = title
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        let episode: PFObject = self.objects![indexPath.row] as! PFObject
        let episodeId: String = episode.objectId! as String
        let userEpisode: PFObject = self.userEpisodes[episodeId] as! PFObject
        let seen: Bool = userEpisode["seen"] as! Bool
        
        if seen {
            var unwatchedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Unwatched" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                userEpisode.setValue(false, forKey: "seen")
                userEpisode.saveInBackgroundWithBlock{
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.userEpisodes[episodeId] = userEpisode
                    } else {
                        println(error)
                    }
                }
                self.tableView.reloadData()
            })
            
            return [unwatchedAction]
        }
        
        var watchedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Watched" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            userEpisode.setValue(true, forKey: "seen")
            userEpisode.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.userEpisodes[episodeId] = userEpisode
                } else {
                    println(error)
                }
            }
            self.tableView.reloadData()
        })
        
        return [watchedAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}
