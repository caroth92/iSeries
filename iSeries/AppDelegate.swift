//
//  AppDelegate.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/4/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("9L2hyftFykqEvu6EgpJdnMhxHIFnTAngAWngsnBU", clientKey: "xBNxZuT4x9dWjN2TkNe3N0kuh65YrZ0YDZ5pWf8X")
        PFFacebookUtils.initializeFacebook()
        
        if PFUser.currentUser() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let seriesVc = storyboard.instantiateViewControllerWithIdentifier("TabController") as! UIViewController
            self.window?.rootViewController = seriesVc
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let seriesVc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            self.window?.rootViewController = seriesVc
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        PFFacebookUtils.session()!.close()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }
}

