//
//  ResultTableCell.swift
//  AccuraSDK
//
//  Created by Deepak Jain on 09/06/19.
//  Copyright © 2019 Elite Development LLC. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblSinglevalue: UILabel!
    
    @IBOutlet weak var viewHeaderData: UIView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var constarintViewHaderHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSide: UILabel!
    @IBOutlet weak var viewLineVartical: UIView!
    @IBOutlet weak var viewLineHorizantal: UIView!
    
    @IBOutlet weak var viewAnsData: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
