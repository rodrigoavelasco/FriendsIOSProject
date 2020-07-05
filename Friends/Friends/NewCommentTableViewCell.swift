//
//  NewCommentTableViewCell.swift
//  Friends
//
//  Created by Andrew Kim on 7/5/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class NewCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var newCommentText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func submitComment(_ sender: Any) {
    }
}
