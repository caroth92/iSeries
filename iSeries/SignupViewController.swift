//
//  SignupViewController.swift
//  iSeries
//
//  Created by Alejandro Cristerna on 3/7/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpViaEmail(sender: AnyObject) {
        var user = PFUser()
        user.username = self.userEmail.text
        user.email = self.userEmail.text
        user.password = self.userPassword.text
        
        user.signUpInBackgroundWithBlock {
            
            (succeeded: Bool!, error: NSError!) -> Void in
        
            if error == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabViewController = storyboard.instantiateViewControllerWithIdentifier("TabController") as UIViewController
                self.presentViewController(tabViewController, animated: true, completion: nil)
            } else {
                // SHOW ERROR
            }
        }
    }
}
