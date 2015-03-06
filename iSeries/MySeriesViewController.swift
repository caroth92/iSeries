//
//  MySeriesViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/4/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class MySeriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func isLoggedIn() -> Bool {
        return PFUser.currentUser() != nil && PFUser.currentUser().isAuthenticated()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

