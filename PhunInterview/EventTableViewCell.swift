//
//  EventTableViewCell.swift
//  PhunInterview
//
//  Created by Mbusi Hlatshwayo on 2/5/17.
//  Copyright © 2017 Mbusi. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    /* outlets for custom table view cell*/
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
