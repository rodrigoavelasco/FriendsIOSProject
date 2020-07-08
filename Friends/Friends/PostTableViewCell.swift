//
//  PostTableViewCell.swift
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
import FirebaseStorage
import AVFoundation
import Foundation

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
    
    var uid: String!
    
    var currentVC: ProfilePageViewController!
    
    var like: Bool?
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
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
    
    func addPost(postID: String) {
        let userDocumentRef = db.collection("posts").document(postID)
        userDocumentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let map = document.data()!
                if map["likes"] != nil {
                    self.likeCount!.text = "\(map["likes"] as! Int)"
                } else {
                    self.db.collection("posts").document(postID).updateData(["likes": 0])
                }
                if map["comments"] != nil {
                    self.commentCount!.text = "\((map["comments"] as! [String]).count)"
                } else{
                    self.db.collection("posts").document(postID).updateData(["comments": []])
                }
                
                self.postText!.text = map["content"] as? String
                self.postDate!.text = map["date"] as? String
                
//                self.postText!.lineBreakMode = NSLineBreakMode.byWordWrapping
//                self.postText!.numberOfLines = 0
//                let tempLabel: UILabel = self.postText!
//                tempLabel.sizeToFit()
//                self.postText!.fr
//                CGSize = CGSize(
                self.postText!.sizeToFit()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
}
