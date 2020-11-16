//
//  CustomTableViewCell.swift
//  PetAssist
//
//  Created by Xcode User on 2020-11-16.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calTitle: UILabel!
    
    @IBOutlet weak var calDetail: UILabel!

    @IBOutlet weak var calStartDate: UILabel!

    @IBOutlet weak var calEndDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
