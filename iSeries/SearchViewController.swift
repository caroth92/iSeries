//
//  SearchViewController.swift
//  iSeries
//
//  Created by Alex Cristerna on 3/21/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchSeries = NSMutableArray()
    var seriesArray:[String] = []
    
    // Search vars
    var searchActive: Bool = false
    var filtered:[String] = []
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - View Lifecycle
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        var query = PFQuery(className: "Series")
        query.orderByAscending("Titulo")
        let results = query.findObjects()
        
        self.searchSeries.addObjectsFromArray(results)
        
        for i in self.searchSeries {
            seriesArray.append(i.valueForKey("Titulo") as NSString)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return filtered.count
        }
        
        return self.searchSeries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as UITableViewCell
        
        if (searchActive) {
            cell.textLabel!.text = filtered[indexPath.row]
        } else {
            cell.textLabel!.text = self.seriesArray[indexPath.row]
        }
        
        return cell
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Search Bar
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = self.seriesArray.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if (filtered.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        
        self.tableView.reloadData()
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

    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Navigation
    //#Mark ------------------------------------------------------------------------------------------------------------------------

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue" {
            let searchDetailViewController = segue.destinationViewController as SearchDetailViewController
            let actualIndexPath = self.tableView.indexPathForSelectedRow()
            let row = actualIndexPath?.row
            let serieObject = self.searchSeries[row!] as PFObject
            searchDetailViewController.serieID = serieObject.valueForKey("objectId") as NSString
        }
    }
}
