//
//  NewsYorkTableViewCell.swift
//  newsApp
//
//  Created by vicente rodriguez on 3/16/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit

class NewsYorkTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
