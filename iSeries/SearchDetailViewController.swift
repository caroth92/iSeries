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
        
        var userSerie = PFQuery(className: "UserSeries")
        userSerie.whereKey("user", equalTo: PFUser.currentUser()!)
        userSerie.whereKey("serie", equalTo: self.serie)
        userSerie.findObjectsInBackgroundWithBlock{(objects:[AnyObject]?,error:NSError?) -> Void in
            if error == nil {
                self.followButton!.setTitle((objects!.count == 0) ? "Follow" : "Unfollow", forState: UIControlState.Normal)
            }
        }

    }
    
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Follow serie action
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func followSerie(sender: AnyObject) {
        
        let state: String = self.followButton!.titleLabel!.text!
        
        if state == "Follow" {
            var addSerie = PFObject(className: "UserSeries")
            addSerie.setValue(PFUser.currentUser()!, forKey: "user")
            addSerie.setValue(self.serie, forKey: "serie")
            addSerie.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if success {
                    self.followButton!.setTitle("Unfollow", forState: UIControlState.Normal)
                    //fillUserHistorial
                }
                
            }
        } else {
            var removeSerieQuery = PFQuery(className: "UserSeries")
            removeSerieQuery.whereKey("user", equalTo: PFUser.currentUser()!)
            removeSerieQuery.whereKey("serie", equalTo: self.serie)
            removeSerieQuery.getFirstObjectInBackgroundWithBlock{
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil && object != nil {
                    object?.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success {
                            self.followButton!.setTitle("Follow", forState: UIControlState.Normal)
                            //deleteUserHistorial
                        }
                    })
                }
            }
        }
    }
    
    func changeUserHistorial(fill: Bool) -> Void {
        
    }
    
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
*/
