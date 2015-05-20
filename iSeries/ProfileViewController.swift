//
//  ProfileViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/7/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var episodesCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userHistorial = PFQuery(className: "UserHistorial")
        userHistorial.whereKey("user", equalTo: PFUser.currentUser()!)
        userHistorial.whereKey("seen", equalTo: true)
        userHistorial.findObjectsInBackgroundWithBlock{(objects:[AnyObject]?,error:NSError?) -> Void in
            if error == nil {
                self.episodesCount.text = String(stringInterpolationSegment: objects!.count)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let seriesVc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        self.presentViewController(seriesVc, animated: true, completion: nil)
    }
}
