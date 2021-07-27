//
//  EditRecommendationForMeListCell.swift
//  BonoCard
//
//  Created by 유하늘 on 2018. 1. 11..
//  Copyright © 2018년 유하늘. All rights reserved.
//

import UIKit

protocol EditRecommendationForMeListCellProtocol {
    func editRecommendationForMeListCellProtocol(editRecommendationForMeListCellProtocol:EditRecommendationForMeListCell)
}

class EditRecommendationForMeListCell: UITableViewCell {

    var delegate:EditRecommendationForMeListCellProtocol?
    @IBOutlet weak var btn_recom: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_recom.layer.cornerRadius = 10

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func recommenderForMeCheckBtn(_ sender: Any) {
        self.delegate?.editRecommendationForMeListCellProtocol(editRecommendationForMeListCellProtocol: self)
    }

    
}
