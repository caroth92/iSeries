//
//  MyEpisodesViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/22/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class MyEpisodesViewController: UITableViewController {
    
    var serieID: NSString!
    var seasons = NSMutableArray()
    var episodes = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userEpisodes:[String] = []
        
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
        
        println(episodes.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("episodeCell", forIndexPath: indexPath) as! UITableViewCell
        
        let object = self.episodes[indexPath.row] as! PFObject
        cell.textLabel!.text = object.valueForKey("Titulo") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var watchedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Watched" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            // Query
        })
        
        return [watchedAction]
    }
    
    /*
    // Override to support conditional editing of the table view.
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
