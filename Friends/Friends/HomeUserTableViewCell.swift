//
//  HomeUserTableViewCell.swift
//  Friends
//
//  Created by Andrew Kim on 6/30/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class HomeUserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var homeUserImageView: UIImageView!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var homeUserNameLabel: UILabel!
    @IBOutlet weak var homeUserPostButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func homeUserPostButtonPressed(_ sender: Any) {
    }
    
}
