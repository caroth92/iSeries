//
//  User.swift
//  iSeries
//
//  Created by Alejandro Cristerna on 3/5/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import Foundation

class User: NSObject {
//    
//    func isLoggedIn() -> Bool {
//        return PFUser.currentUser() != nil && PFUser.currentUser().isAuthenticated()
//    }
//    
//    func requestFacebookInfo() {
//        let request = FBRequest.requestForMe()
//        request.startWithCompletionHandler({ (connection, result, error) -> Void in
//            if error == nil {
//                if let userData = result as? NSDictionary {
//                    
//                    let facebookId = userData["id"] as String
//                    self.user.name = userData["name"] as String
//                    self.user.imgUrl = NSURL(string: NSString(format: "https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId))
//                    self.user.isFacebookUser = true
//                }
//            } else {
//                if let userInfo = error.userInfo {
//                    
//                    if let type: AnyObject = userInfo["error"] {
//                        
//                        if let msg = type["type"] as? String {
//                            if msg == "OAuthException" { // Since the request failed, we can check if it was due to an invalid session
//                                println("The facebook session was invalidated")
//                                self.onLogout("")
//                                return
//                            }
//                        }
//                    }
//                }
//                
//                println("Some other error: \(error)")
//            }
//        })
//    }
//    
//    func requestUserInfo() {
//        if let pfUser = PFUser.currentUser() {
//            user.name = pfUser.username
//            user.isFacebookUser = false
//            user.imgUrl = nil
//        }
//    }
//    
//    func onLogout(sender : AnyObject) {
//        PFUser.logOut()
//    }
    
}
