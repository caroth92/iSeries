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
    
    var images:[PFFile] = []
    var titles:[String] = []
    var series:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadNewReleases{(objects, error) -> () in
            for object in objects {
                let temporada = object["temporada"]! as! PFObject
                let serie = temporada["serie"]! as! PFObject
                let title = object["Titulo"] as! String
                self.titles.append(title)
                let serieTitle = serie["Titulo"] as! String
                self.series.append(serieTitle)
                let image = serie["Imagen"] as! PFFile
                self.images.append(image)
            }
            self.collectionView.reloadData()
        }
    }
    
    func loadNewReleases(callback: ([PFObject]!,NSError!) -> ()) {
        let date = NSDate()
        var query = PFQuery(className: "Episodio")
        query.whereKey("Aired", greaterThan: date)
        query.includeKey("temporada")
        query.includeKey("temporada.serie")
        
        query.findObjectsInBackgroundWithBlock{(objects:[AnyObject]?,error:NSError?) -> Void in
            if error == nil {
                callback(objects as? [PFObject], error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    //#Mark: - Collection view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DiscoCell
        
        cell.titulo.text = self.titles[indexPath.row]
        cell.serie.text = self.series[indexPath.row]
        let imagePFFile = self.images[indexPath.row]
        imagePFFile.getDataInBackgroundWithBlock{
            (imageData: NSData?, error: NSError?) -> Void in
            if (!(error != nil)) {
                cell.portada.image = UIImage(data: imageData!)
            }
        }
        
        return cell
    }
}
