//
//  MySeriesViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/22/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class MySeriesViewController: UITableViewController {
    
    var userSeries = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userSeries.removeAllObjects()
        
        self.loadUserSeries{(objects, error) -> () in
            for object in objects {
                var query = PFQuery(className: "Series")
                let serieID = object.valueForKey("SerieId") as NSString
                let serie = query.getObjectWithId(serieID)
                self.userSeries.addObject(serie)
            }
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserSeries(callback: ([PFObject]!,NSError!) -> ()) {
        var query = PFQuery(className: "UserSeries")
        query.whereKey("UserId", equalTo: PFUser.currentUser().objectId)
        
        query.findObjectsInBackgroundWithBlock{(objects:[AnyObject]!,error:NSError!) -> Void in
            if error == nil {
                callback(objects as [PFObject], error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.userSeries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("serieCell", forIndexPath: indexPath) as UITableViewCell

        let object = self.userSeries[indexPath.row] as PFObject
        cell.textLabel!.text = object.valueForKey("Titulo") as NSString
        
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
        if segue.identifier == "segue" {
            let myEpisodeViewController = segue.destinationViewController as MyEpisodeViewController
            let actualIndexPath = self.tableView.indexPathForSelectedRow()
            let row = actualIndexPath?.row
            let serieObject = self.userSeries[row!] as PFObject
            myEpisodeViewController.serieID = serieObject.valueForKey("objectId") as NSString
        }
    }

}
