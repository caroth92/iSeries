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
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark - View Lifecycle
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark - Dismiss ViewController
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark - Sign Up
    //#Mark ------------------------------------------------------------------------------------------------------------------------

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
                var alert = UIAlertController(title: "Error", message: "Sorry, we were not able to create your account. Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
