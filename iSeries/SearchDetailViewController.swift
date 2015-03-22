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
    
    
    @IBOutlet weak var followButton: UIButton!
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
        
        self.loadSerie { (object, error) -> () in
            self.serieLabel.text! = object.valueForKey("Titulo") as NSString
            self.countryLabel.text! = object.valueForKey("Country") as NSString
            self.genreLabel.text! = object.valueForKey("Genero") as NSString
            //descriptionLabel.text! = serie.valueForKey("Descripcion") as NSString
            
            let userImageFile = object.valueForKey("Imagen") as PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData!, error: NSError!) -> Void in
                if !(error != nil) {
                    self.serieImage.image = UIImage(data:imageData)
                }
            }
        }
        
        self.loadSeasons{ (objects, error) -> () in
            for object in objects {
                self.seasons.addObject(object)
            }
            self.seasonsTable.reloadData()
        }
        
        //var querySeason = PFQuery(className: "Temporada")
        //querySeason.whereKey("Serie", equalTo: serieID)
        //querySeason.addAscendingOrder("NumTemporada")
        //let result = querySeason.findObjects()
        //self.seasons.addObjectsFromArray(result)
    }
    
    func loadSerie(callback: (PFObject, NSError!) -> ()) {
        var query = PFQuery(className: "Series")
        query.whereKey("objectId", equalTo: self.serieID)
        
        query.findObjectsInBackgroundWithBlock{(objects:[AnyObject]!,error:NSError!) -> Void in
            if error == nil {
                callback(objects.first as PFObject ,error)
            }
        }
        
    }
    
    func loadSeasons(callback: ([PFObject]!,NSError!) -> ()) {
        var query = PFQuery(className: "Temporada")
        query.whereKey("Serie", equalTo: serieID)
        query.addAscendingOrder("NumTemporada")
        
        query.findObjectsInBackgroundWithBlock{(objects:[AnyObject]!,error:NSError!) -> Void in
            if error == nil {
                callback(objects as [PFObject] ,error)
            }
        }
        
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
        let numTemporada = object.valueForKey("NumTemporada") as NSString
        cell.textLabel!.text = "Season " + numTemporada
        
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
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Add serie
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func followSerie(sender: AnyObject) {
        let userID = PFUser.currentUser().objectId as NSString
        
        var userSerie = PFObject(className: "UserSeries")
        userSerie["UserId"] = userID
        userSerie["SerieId"] = self.serieID
        userSerie.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if success {
                self.followButton!.enabled = false
            }
        }

    }
    
}
