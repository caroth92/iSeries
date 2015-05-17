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
    //var serie: NSString!
    //var seasons = NSMutableArray()
    //var episodes = NSMutableArray()
    
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
        
        /*var userEpisodes:[String] = []
        
        var querySeason = PFQuery(className: "Temporada")
        querySeason.whereKey("Serie", equalTo: serieID)
        let result = querySeason.findObjects()
        self.seasons.addObjectsFromArray(result!)
        
        var queryEpisodes = PFQuery(className: "Episodio")
        
        for season in self.seasons {
        queryEpisodes.whereKey("Temporada", equalTo: (season.objectId as String?)!)
        let results = queryEpisodes.findObjects()
        self.episodes.addObjectsFromArray(results!)
        }
        
        println(episodes.count)*/
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
                    /*if let seen = object!["seen"] as? Bool {
                        let episode = object!["episodio"] as? PFObject
                        self.episodeState[episode!.objectId!] = seen
                    }*/
                }
            }
        }
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.episodes.count
    }
    */
    
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
        
        /*if let seen = episode["seen"] as? Bool {
            var unwatchedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Unwatched" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                
                var query = PFQuery(className: "UserHistorial")
                query.whereKey("episodio", equalTo: episode)
                query.whereKey("user", equalTo: PFUser.currentUser()!)
                query.getFirstObjectInBackgroundWithBlock{
                    (object: PFObject?, error: NSError?) -> Void in
                    if error == nil && object != nil {
                        object!.setValue(false, forKey: "seen")
                        object!.saveInBackgroundWithBlock{
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                
                            } else {
                                println(error)
                            }
                        }
                    } else {
                        println(error)
                    }
                }
                
                self.tableView.reloadData()
            })
            
            return [unwatchedAction]
        }
        
        var watchedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Watched" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            var query = PFQuery(className: "UserHistorial")
            query.whereKey("episodio", equalTo: episode)
            query.whereKey("user", equalTo: PFUser.currentUser()!)
            query.getFirstObjectInBackgroundWithBlock{
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil && object != nil {
                    object!.setValue(true, forKey: "seen")
                    object!.saveInBackgroundWithBlock{
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            
                        } else {
                            println(error)
                        }
                    }
                } else {
                    println(error)
                }
            }
            
            self.tableView.reloadData()
        })
        
        return [watchedAction]*/
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    /* Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
