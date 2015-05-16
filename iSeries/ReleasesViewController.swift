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
    
    let discos = ["1.jpg", "2.jpg", "3.jpg","4.jpg","5.jpg","6.jpg","7.jpg","8.jpg","9.jpg","10.jpg","11.jpg","12.jpg","13.jpg","14.jpg","15.jpg","16.jpg","17.jpg","18.jpg","19.jpg"]
    
    var images:[PFFile] = []
    var titles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadNewReleases{(objects, error) -> () in
            for object in objects {
                let temporada = object["temporada"]! as! PFObject
                let serie = temporada["serie"]! as! PFObject
                let title = serie["Titulo"] as! String
                self.titles.append(title)
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
    //#Mark: - Table view data source
    //#Mark ------------------------------------------------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DiscoCell
        
        //cell.portada.image = UIImage(named: self.discos[indexPath.row])
        cell.titulo.text = self.titles[indexPath.row]
        let imagePFFile = self.images[indexPath.row]
        imagePFFile.getDataInBackgroundWithBlock{
            (imageData: NSData?, error: NSError?) -> Void in
            if (!(error != nil)) {
                cell.portada.image = UIImage(data: imageData!)
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredVertically)
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! DiscoCell
    }
}
