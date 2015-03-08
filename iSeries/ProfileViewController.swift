//
//  ProfileViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/7/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let seriesVc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        self.presentViewController(seriesVc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
