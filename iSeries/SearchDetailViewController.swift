//
//  SearchDetailViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/21/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    var serie: PFObject!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - View Lifecycle
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.serie["Titulo"] as? String
        self.genreLabel.text = self.serie["Genero"] as? String
        self.countryLabel.text = self.serie["Country"] as? String
        
        let imagePFFile: PFFile = self.serie["Imagen"] as! PFFile
        imagePFFile.getDataInBackgroundWithBlock{
            (imageData: NSData?, error: NSError?) -> Void in
            if (!(error != nil)) {
                self.imageView.image = UIImage(data: imageData!)
            }
        }

    }
    
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Follow serie action
    //#Mark ------------------------------------------------------------------------------------------------------------------------

    @IBOutlet weak var followSerie: UIButton!
    
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        var searchDetailTableViewController = segue.destinationViewController as! SearchDetailTableViewController
        searchDetailTableViewController.serie = self.serie
    }
}


/*
class SearchDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var serie:  PFObject!
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
        
        var userSeries:[String] = []
        
        self.loadSerie { (object, error) -> () in
            self.serieLabel.text! = object.valueForKey("Titulo") as! String
            self.countryLabel.text! = object.valueForKey("Country") as! String
            self.genreLabel.text! = object.valueForKey("Genero") as! String
            //descriptionLabel.text! = serie.valueForKey("Descripcion") as NSString
            
            let userImageFile = object.valueForKey("Imagen") as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if !(error != nil) {
                    self.serieImage.image = UIImage(data:imageData!)
                }
            }
        }
        
        /*var query = PFQuery(className: "Series")
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
        }*/
        
        var queryUserSeries = PFQuery(className: "UserSeries")
        queryUserSeries.whereKey("UserId", equalTo: PFUser.currentUser()!.objectId!)
        queryUserSeries.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        userSeries.append(object.valueForKey("SerieId") as! String)
                    }
                    if contains(userSeries, self.serieID! as String) {
                        self.followButton!.enabled = false
                    }
                }
            }
            
        }
        
        var querySeason = PFQuery(className: "Temporada")
        querySeason.whereKey("Serie", equalTo: serieID)
        querySeason.addAscendingOrder("NumTemporada")
        let result = querySeason.findObjects()
        self.seasons.addObjectsFromArray(result!)
    }
    
    func loadSerie(callback: (PFObject, NSError!) -> ()) {
        var query = PFQuery(className: "Series")
        query.whereKey("objectId", equalTo: self.serieID)
        
        query.findObjectsInBackgroundWithBlock{(objects:[AnyObject]?, error:NSError?) -> Void in
            if error == nil {
                callback((objects!.first as? PFObject)!, error)
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
        let cell = seasonsTable.dequeueReusableCellWithIdentifier("seasonCell", forIndexPath: indexPath) as! UITableViewCell
        
        let object = self.seasons[indexPath.row] as! PFObject
        let numTemporada = object.valueForKey("NumTemporada") as! NSString
        cell.textLabel!.text = "Season " + (numTemporada as String)
        
        return cell
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Navigation
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue" {
            let episodeViewController = segue.destinationViewController as! EpisodesTableViewController
            let actualIndexPath = self.seasonsTable.indexPathForSelectedRow()
            let row = actualIndexPath?.row
            let serieObject = self.seasons[row!] as! PFObject
            episodeViewController.seasonID = serieObject.valueForKey("objectId") as! NSString
        }
    }


    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Add serie
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func followSerie(sender: AnyObject) {
        let userID = (PFUser.currentUser()!.objectId as String?)!
        
        var userSerie = PFObject(className: "UserSeries")
        userSerie["UserId"] = userID
        userSerie["SerieId"] = self.serieID
        userSerie.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                self.followButton!.enabled = false
                self.fillUserHistory()
            }
        }
        
    }
    
    func fillUserHistory() {
        let userID = (PFUser.currentUser()!.objectId as NSString?)!
        var episodes = NSMutableArray()
        var queryEpisodes = PFQuery(className: "Episodio")
        
        for season in self.seasons {
            var seasonID = (season.objectId as String?)!
            queryEpisodes.whereKey("Temporada", equalTo: seasonID)
            var results = queryEpisodes.findObjects()
            episodes.addObjectsFromArray(results!)
        }
        
        for episode in episodes {
            var userHistorial = PFObject(className: "UserHistorial")
            userHistorial["UserId"] = userID
            userHistorial["EpisodeId"] = episode.objectId
            userHistorial.save()
            println(episode.objectId)
        }
    }
}
*/
