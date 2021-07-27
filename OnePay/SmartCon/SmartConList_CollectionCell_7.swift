//
//  SmartConList_CollectionCell_7.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 4. 3..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class SmartConList_CollectionCell_7: UICollectionViewCell {
    @IBOutlet weak var smartConList_CollCellImage: UIImageView!
    @IBOutlet weak var smartConList_Brand_Name_Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        smartConList_CollCellImage.layer.borderWidth = 0.5
        smartConList_CollCellImage.layer.borderColor = UIColor.lightGray.cgColor
        smartConList_CollCellImage.layer.cornerRadius = 5
        // Initialization code
    }
}
