//
//  MyEpisodesViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/22/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class MyEpisodesViewController: PFQueryTableViewController {
    
    //var serie: PFObject!
    var serie: NSString!
    var seasons = NSMutableArray()
    var episodes = NSMutableArray()
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "UserHistorial"
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
        var query = PFQuery(className: "UserHistorial")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.includeKey("episodio")
        query.includeKey("episodio.temporada")
        query.includeKey("episodio.temporada.serie")
        
        return query
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
        let cell = tableView.dequeueReusableCellWithIdentifier("episodeCell", forIndexPath: indexPath) as! PFTableViewCell
        
        /*let episodio = object?["episodio"] as! PFObject
        let temporada = episodio["temporada"] as! PFObject
        let serie = temporada["serie"] as! PFObject
        let titulo = serie["Titulo"] as! String
        */
        if let title = object?["episodio"]?["Titulo"] as? String {
            cell.textLabel!.text = title
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var watchedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Watched" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            // Query
            
            self.tableView.reloadData()
        })
        
        return [watchedAction]
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
