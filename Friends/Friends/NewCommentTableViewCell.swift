//
//  NewCommentTableViewCell.swift
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


class NewCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var newCommentText: UITextView!
    var postID: String!
    let db = Firestore.firestore()
    var commentTVC: CommentsTableViewController!
    @IBOutlet var submitCommentButton: UIButton!
    @IBAction func typeCommentButton(_ sender: Any) {
        newCommentText!.text = ""
        if globalDark {
            newCommentText!.textColor = UIColor.white
            self.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        } else {
            newCommentText!.textColor = UIColor.black
            
            self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        }
        newCommentText.becomeFirstResponder()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if globalDark {
            newCommentText!.textColor = UIColor.white
            contentView.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
            backgroundColor = UIColor(white: 0.05, alpha: 1.0)
            submitCommentButton!.setImage(UIImage(named: "submitcomment-negative")!, for: .normal)
        } else {
            newCommentText!.textColor = UIColor.black
            contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            submitCommentButton!.setImage(UIImage(named: "submitcomment")!, for: .normal)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func submitComment(_ sender: Any) {
        let comment = newCommentText!.text!
        if comment != "" && comment != "Type comment here" {
            var ref: DocumentReference? = nil
            let uid = Auth.auth().currentUser!.uid
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            
            ref = db.collection("comments").addDocument(data: [
                "uid": uid,
                "date": dateString,
                "comment": comment,
                "post": self.postID!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    self.db.collection("posts").document(self.postID).updateData(["comments": FieldValue.arrayUnion([ref!.documentID])]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            self.newCommentText!.textColor = UIColor(white: 0.5, alpha: 1.0)
                            self.newCommentText!.text = "Type comment here"
                            self.commentTVC!.addComments()
                                
                            
                        }
                    }
                }
            }
        }
    }
}
