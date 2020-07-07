//
//  FriendTableViewCell.swift
//  Friends
//
//  Created by Andrew Kim on 7/4/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    var uid: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
