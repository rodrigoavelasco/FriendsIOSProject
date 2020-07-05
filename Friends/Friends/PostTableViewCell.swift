//
//  PostTableViewCell.swift
//  Friends
//
//  Created by Andrew Kim on 7/5/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        like = false
    }

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var like: Bool?
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if !like! {
            var count = Int(likeCount!.text!)!
            count += 1
            likeCount!.text = "\(count)"
            likeButton.setImage(UIImage(named: "heart-selected"), for: .normal)
            like = true
        } else {
            var count = Int(likeCount!.text!)!
            count -= 1
            likeCount!.text = "\(count)"
            likeButton.setImage(UIImage(named: "heart-unselected"), for: .normal)
            like = false
        }
    }
    

}
