//
//  SiteCell.swift
//  W8SwiftTables2
//
//  Created by Jawaad Sheikh on 2018-03-14.
//  Copyright © 2018 Jawaad Sheikh. All rights reserved.
//

import UIKit

class SiteCell: UITableViewCell {
    
    
    let primaryLabel = UILabel()
    let secondaryLabel = UILabel()
    let myImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        
        primaryLabel.textAlignment = NSTextAlignment.left
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 18)
        primaryLabel.backgroundColor = UIColor.clear
        primaryLabel.textColor = UIColor.black
        
        secondaryLabel.textAlignment = NSTextAlignment.left
        secondaryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        secondaryLabel.backgroundColor = UIColor.clear
        secondaryLabel.textColor = UIColor.blue
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(myImageView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        var f = CGRect(x: 100, y: 5, width: 460, height: 30)
        primaryLabel.frame = f
        
        f = CGRect(x: 100, y: 40, width: 460, height: 20)
        secondaryLabel.frame = f
        
        f = CGRect(x: 5, y: 5, width: 80, height: 80)
        myImageView.frame = f
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
