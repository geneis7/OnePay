//
//  EditRecommenderListCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 3. 7..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

class EditRecommenderListCell: UITableViewCell {

    @IBOutlet weak var editRecommenderListCell_Id_TF: UILabel!
    @IBOutlet weak var editRecommenderListCell_Name_TF: UILabel!
    @IBOutlet weak var editRecommenderListCell_Date_TF: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
