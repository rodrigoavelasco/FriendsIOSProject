//
//  CommentTableViewCell.swift
//  Friends
//
//  Created by Andrew Kim on 7/5/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

import Firebase
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentText: UILabel!
    let db = Firestore.firestore()
    
    var commentID: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addComment(commentID: String) {
        let docsRef = db.collection("comments").document(commentID)
        
        docsRef.getDocument() { (document, error) in
            if error != nil {
                print(error!)
                return
            }
            let map = document!.data()!
            let userID = map["uid"] as! String
            let userRef = self.db.collection("users").document(userID)
            userRef.getDocument() { (user, error) in
                if error != nil {
                    print(error!)
                    return
                }
                let userMap = user!.data()!
                if userMap["image"] != nil {
                    self.userImage.load(url: URL(string: (userMap["image"] as! String))!)
                } else {
                    self.userImage!.image = UIImage(named: "blank-profile-picture")
                }
                self.userName!.text = userMap["name"] as! String
                
                self.commentDate!.text = map["date"] as! String
                self.commentText!.text = map["comment"] as! String
                self.commentText!.sizeToFit()
            }
        }
    }
}
