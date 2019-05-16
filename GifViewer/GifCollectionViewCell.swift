//
//  GifCollectionViewCell.swift
//  GifViewer
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 mahesh lad. All rights reserved.
//

import UIKit
import FLAnimatedImage

class GifCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var cellGifView: FLAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
