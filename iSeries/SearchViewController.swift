//
//  SearchViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/21/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

extension UITableView {
    func hideSearchBar() {
        if let bar = self.tableHeaderView as? UISearchBar {
            let height = CGRectGetHeight(bar.frame);
            let offset = self.contentOffset.y
            if offset < height {
                self.contentOffset = CGPointMake(0, height);
            }
        }
    }
}

class SearchViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var seriesArray:[String] = []
    
    // Search vars
    var searchActive: Bool = false
    var filtered:[String] = []
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - View Lifecycle
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Series"
        self.textKey = "Titulo"
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        // Hide searchBar
        self.tableView.hideSearchBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Parse table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Series")
        query.orderByAscending("Titulo")
        return query
    }
    
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)

        // Add serie's title to search array
        for object in self.objects! {
            if let title = object["Titulo"] as? String {
                self.seriesArray.append(title)
            }
        }
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return self.filtered.count
        } else {
            return self.objects!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PFTableViewCell

        if (searchActive) {
            let row = indexPath.row
            cell.textLabel!.text = filtered[indexPath.row]
        } else {
            if let title = object?["Titulo"] as? String {
                cell.textLabel!.text = title
            }
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
        
        self.filtered = self.seriesArray.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
         
            return range.location != NSNotFound
        })
        
        if (self.filtered.count == 0) {
            self.searchActive = false
        } else {
            self.searchActive = true
        }
        
        self.tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    }
    */
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Navigation
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        var searchDetailViewController = segue.destinationViewController as! SearchDetailViewController
        
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let row = Int(indexPath.row)
            let serie = objects?[row] as! PFObject
            //let serie = userSerie["serie"] as! PFObject
            searchDetailViewController.serie = serie
        }
        
        /*let searchDetailViewController = segue.destinationViewController as! SearchDetailViewController
        let actualIndexPath = self.tableView.indexPathForSelectedRow()
        let row = actualIndexPath?.row
        let serieObject = self.searchSeries[row!] as! PFObject
        searchDetailViewController.serieID = serieObject.valueForKey("objectId") as! NSString*/
        
    }
}
