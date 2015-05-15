//
//  ReleasesViewController.swift
//  iSeries
//
//  Created by Carolina De La Torre on 3/21/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class ReleasesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func loadNewReleases(callback: ([PFObject]!,NSError!) -> ()) {
        let date = NSDate()
        var query = PFQuery(className: "Episodios")
        query.whereKey("Aired", greaterThan: date)
        query.includeKey("Temporada")
        
        query.findObjectsInBackgroundWithBlock{(objects:[AnyObject]?,error:NSError?) -> Void in
            if error == nil {
                callback(objects as! [PFObject], error)
            }
        }
    }
    
    let discos = ["1.jpg", "2.jpg", "3.jpg","4.jpg","5.jpg","6.jpg","7.jpg","8.jpg","9.jpg","10.jpg","11.jpg","12.jpg","13.jpg","14.jpg","15.jpg","16.jpg","17.jpg","18.jpg","19.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadNewReleases{(objects, error) -> () in
            for object in objects {
                var query = PFQuery(className: "Temporada")
                let temporada = object.valueForKey("Temporada") as! String
                query.whereKey("objectId", equalTo: temporada)
                //let serie = query.getObjectWithId(serieID as String)
                //self.userSeries.addObject(serie!)
                println(object)
                println("entre")
            }
            //self.tableView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.discos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DiscoCell
        
        cell.portada.image = UIImage(named: self.discos[indexPath.row])
        cell.titulo.text = self.discos[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredVertically)
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! DiscoCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
