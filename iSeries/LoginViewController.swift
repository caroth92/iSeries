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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginViaEmail(sender: AnyObject) {
        // TODO: Save and send credentials
        
        PFUser.logInWithUsernameInBackground(self.userEmail.text, password:self.userPassword.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabViewController = storyboard.instantiateViewControllerWithIdentifier("TabController") as UIViewController
                self.presentViewController(tabViewController, animated: true, completion: nil)
            } else {
                println("sorry")
            }
        }
    }

    @IBAction func loginViaFacebook(sender: AnyObject) {
        let permissionsArray = ["user_about_me"]
        
        PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user, error) -> Void in

            if((error) != nil) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let seriesVc = storyboard.instantiateViewControllerWithIdentifier("TabController") as UIViewController
                self.presentViewController(seriesVc, animated: true, completion: nil)
            }
                
            if self.delegate != nil {
                self.delegate!.loginViaFacebook(self)
            }
        })
        
    }
}
