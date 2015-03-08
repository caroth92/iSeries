//
//  MySeriesViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/4/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class MySeriesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutViaFacebook(sender: AnyObject) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let seriesVc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        self.presentViewController(seriesVc, animated: true, completion: nil)
    }
}

