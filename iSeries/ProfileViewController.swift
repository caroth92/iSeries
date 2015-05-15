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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let request:FBRequest = FBRequest.requestForMe()
            request.startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                if error == nil{
                    if let dict = result as? Dictionary<String, AnyObject>{
                        let name:String = dict["name"] as AnyObject? as! String
                        let facebookID:String = dict["id"] as AnyObject? as! String
                        
                        let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                        
                        var URLRequest = NSURL(string: pictureURL)
                        var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                        
                        self.userName.text = name
                        
                        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                            if error == nil {
                                var picture = PFFile(data: data)
                                PFUser.currentUser()!.setObject(picture, forKey: "profilePicture")
                            } else {
                                println("Error: \(error.localizedDescription)")
                            }
                        })
                        PFUser.currentUser()!.setValue(name, forKey: "username")
                    }
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
