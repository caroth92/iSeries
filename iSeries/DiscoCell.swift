//
//  DiscoCell.swift
//  iSeries
//
//  Created by Carolina De La Torre on 5/14/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

import UIKit

class DiscoCell: UICollectionViewCell {
    
    @IBOutlet weak var portada: UIImageView!

    @IBOutlet weak var titulo: UILabel!
    
    var imagenPortada: UIImage?
    var title: String = ""
}
