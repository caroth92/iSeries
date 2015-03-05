//
//  LogoutViewController.swift
//  iSeries
//
//  Created by Alejandro Cristerna on 3/4/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutViaFacebook(sender: AnyObject) {
        PFUser.logOut()
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("login") as LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
