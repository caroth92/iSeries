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
    
    var delegate : LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginViaFacebook(sender: AnyObject) {
        let permissionsArray = ["user_about_me"]
        
        PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user, error) -> Void in
            if user == nil {
                println("error")
            } else {
                if user.isNew {
                    println("User signed up and login")
                } else {
                    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("logout") as LogoutViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                    println("User logged in")
                }
                
                if self.delegate != nil {
                    self.delegate!.loginViaFacebook(self)
                }
            }
            
            
        })
        
    }
}
