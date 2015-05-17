//
//  EpisodesTableViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/21/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class EpisodesTableViewController: PFQueryTableViewController {
    
    var season: PFObject!
    //var seasonID: NSString!
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
        
        /*var query = PFQuery(className: "Episodio")
        query.whereKey("Temporada", equalTo: seasonID)
        query.addAscendingOrder("Aired")
        
        let result = query.findObjects()
        self.episodes.addObjectsFromArray(result!)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Parse table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Episodio")
        query.whereKey("temporada", equalTo: self.season)
        query.orderByDescending("Aired")
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PFTableViewCell
        
        if let title = object?["Titulo"] as? String {
            cell.textLabel!.text = title
        }
        
        return cell
    }

    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Navigation
    //#Mark ------------------------------------------------------------------------------------------------------------------------

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}
