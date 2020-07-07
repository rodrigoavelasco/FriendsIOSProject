//
//  User.swift
//  Friends
//
//  Created by Andrew Kim on 7/5/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class User {
    
    var email: String!
    var username: String!
    var uid: String!
    var name: String!
    var birthday: String!
    var phone: String!
    var image: UIImage!
    var location: String!
    
    let db = Firestore.firestore()
    
    init(uid: String) {
        self.uid = uid
        let userDocumentRef = db.collection("users").document(uid)
        userDocumentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let map = document.data()!
                self.name = map["name"] as? String
                self.email = map["email"] as? String
                self.username = map["username"] as? String
                if map["birthday"] != nil {
                    self.birthday = map["birthday"] as? String
                }
                if map["phone"] != nil {
                    self.phone = map["phone"] as? String
                }
                if map["image"] != nil {
                    self.image = UIImage(named: (map["image"] as? String)!)
                }
                if map["location"] != nil {
                    self.location = map["location"] as? String
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
