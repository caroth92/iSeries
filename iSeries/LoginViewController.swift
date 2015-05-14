//
//  LoginViewController.swift
//  iSeries
//
//  Created by Alejandro Cristerna on 3/4/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func loginViaFacebook(loginViewController : LoginViewController)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    
    var delegate : LoginViewControllerDelegate?
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - View Lifecycle
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Login Via Email
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func loginViaEmail(sender: AnyObject) {
        // TODO: Save and send credentials
        
        PFUser.logInWithUsernameInBackground(self.userEmail.text, password:self.userPassword.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabViewController = storyboard.instantiateViewControllerWithIdentifier("TabController") as! UIViewController
                self.presentViewController(tabViewController, animated: true, completion: nil)
            } else {
                var alert = UIAlertController(title: "Login failed", message: "Sorry, the login failed. Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Login Via Facebook
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func loginViaFacebook(sender: AnyObject) {
        let permissionsArray = ["user_about_me"]
        
        PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user, error) -> Void in

            if((error) != nil) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let seriesVc = storyboard.instantiateViewControllerWithIdentifier("TabController") as! UIViewController
                self.presentViewController(seriesVc, animated: true, completion: nil)
            }
                
            if self.delegate != nil {
                self.delegate!.loginViaFacebook(self)
            }
        })
        
    }
}
