//
//  MySeriesViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/22/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class MySeriesViewController: PFQueryTableViewController {
    
    var userSeries = NSMutableArray()
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "UserSeries"
        self.textKey = "Titulo"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /*override func viewWillAppear(animated: Bool) {
        var query = PFQuery(className: "Series")
        var queryUserSeries = PFQuery(className: "UserSeries")
        
        let userID = PFUser.currentUser()!.objectId
        queryUserSeries.whereKey("UserId", equalTo: userID!)
        let results = queryUserSeries.findObjects()
        
        self.userSeries.removeAllObjects()
        for result in results {
            let serieID = result.valueForKey("SerieId") as NSString
            let serie = query.getObjectWithId(serieID)
            self.userSeries.addObject(serie)
        }
        super.viewWillAppear(animated)
        
        self.userSeries.removeAllObjects()
        
        self.loadUserSeries{(objects, error) -> () in
            for object in objects {
                var query = PFQuery(className: "Series")
                let serieID = object.valueForKey("SerieId") as! NSString
                let serie = query.getObjectWithId(serieID as String)
                self.userSeries.addObject(serie!)
            }
            self.tableView.reloadData()
        }
    }
    
    func loadUserSeries(callback: ([PFObject]!,NSError!) -> ()) {
        var query = PFQuery(className: "UserSeries")
        query.whereKey("UserId", equalTo: PFUser.currentUser()!.objectId!)
        
        query.findObjectsInBackgroundWithBlock{(objects:[AnyObject]?,error:NSError?) -> Void in
            if error == nil {
                callback(objects as! [PFObject], error)
            }
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Parse table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "UserSeries")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.includeKey("serie")
        
        return query
    }

    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.userSeries.count
    }*/

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("serieCell", forIndexPath: indexPath) as! PFTableViewCell
        
        if let title = object?["serie"]?["Titulo"] as? String {
            cell.textLabel!.text = title
        }
        
        return cell
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
        // Get the new view controller using [segue destinationViewController].
        var myEpisodesViewController = segue.destinationViewController as! MyEpisodesViewController
	
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let row = Int(indexPath.row)
            let userSerie = objects?[row] as! PFObject
            let serie = userSerie["serie"] as! PFObject
            let titulo = serie["Titulo"] as? String
            myEpisodesViewController.serie = serie["Titulo"] as? String
        }
    }

}
