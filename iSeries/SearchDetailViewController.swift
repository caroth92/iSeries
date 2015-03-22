//
//  SearchDetailViewController.swift
//  iSeries
//
//  Created by Alex Cristerna on 3/21/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var serieID: NSString!
    var seasons = NSMutableArray()
    
    @IBOutlet weak var serieLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var serieImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var seasonsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className: "Series")
        let serie = query.getObjectWithId(serieID)
        
        serieLabel.text! = serie.valueForKey("Titulo") as NSString
        countryLabel.text! = serie.valueForKey("Country") as NSString
        genreLabel.text! = serie.valueForKey("Genero") as NSString
        //descriptionLabel.text! = serie.valueForKey("Descripcion") as NSString
        
        let userImageFile = serie.valueForKey("Imagen") as PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData!, error: NSError!) -> Void in
            if !(error != nil) {
                self.serieImage.image = UIImage(data:imageData)
            }
        }
        
        var querySeason = PFQuery(className: "Temporada")
        querySeason.whereKey("Serie", equalTo: serieID)
        querySeason.addAscendingOrder("NumTemporada")
        let result = querySeason.findObjects()
        self.seasons.addObjectsFromArray(result)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Scroll
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = self.contentView.bounds.size
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    func numberOfSectionsInTableView(seasonsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(seasonsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seasons.count
    }
    
    func tableView(seasonsTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = seasonsTable.dequeueReusableCellWithIdentifier("seasonCell", forIndexPath: indexPath) as UITableViewCell
        
        let object = self.seasons[indexPath.row] as PFObject
        cell.textLabel!.text = object.valueForKey("NumTemporada") as NSString
        
        return cell
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Navigation
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue" {
            let episodeViewController = segue.destinationViewController as EpisodesTableViewController
            let actualIndexPath = self.seasonsTable.indexPathForSelectedRow()
            let row = actualIndexPath?.row
            let serieObject = self.seasons[row!] as PFObject
            episodeViewController.seasonID = serieObject.valueForKey("objectId") as NSString
        }
    }
    
    @IBAction func followSerie(sender: AnyObject) {
        
    }
    
}
