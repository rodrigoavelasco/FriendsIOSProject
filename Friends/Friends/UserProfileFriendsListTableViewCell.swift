//
//  UserProfileFriendsListTableViewCell.swift
//  Friends
//
//  Created by Andrew Kim on 7/4/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserProfileFriendsListTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (uid != nil) {
            let userDocumentRef = db.collection("users").document(uid!)
            userDocumentRef.getDocument{ (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    let map = document.data()!
                    if map["friends"] != nil {
                        self.friends = map["friends"] as? [String]
                    }
                } else {
                    print("Document does not exist")
                }
            }
            return friends != nil ? friends!.count : 0
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsList.dequeueReusableCell(withIdentifier: "Friend", for: indexPath as IndexPath) as! FriendTableViewCell
        cell.uid = friends![indexPath.row]
        let userDocumentRef = db.collection("users").document(friends![indexPath.row])
        userDocumentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let map = document.data()!
                if map["image"] != nil {
                    cell.friendImage!.image = UIImage(named: "blank-profile-picture")
                }
                cell.friendName!.text = map["name"] as? String
            } else {
                print("Document does not exist")
            }
        }

        return cell
    }
    

    @IBOutlet weak var friendsList: UITableView!
    
    var uid: String! {
        didSet{
            friendsList.reloadData()
        }
    }
    var friends: [String]!
    let db = Firestore.firestore()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendsList.delegate = self
        friendsList.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
