//
//  FaceMatchResultTableViewCell.swift
//  AccuraSDK
//
//  Created by Technozer on 08/02/20.
//  Copyright © 2020 Elite Development LLC. All rights reserved.
//

import UIKit

class FaceMatchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
