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
        if (postID != nil) {
            let likeDocumentRef = db.collection("posts").document(postID)
            likeDocumentRef.getDocument{ (document, error) in
                
                if let document = document, document.exists {
                    let map = document.data()!
                    if map["likes"] != nil {
                        let likes = map["likes"] as! [String]
                        if !likes.contains(Auth.auth().currentUser!.uid) {
                            if globalDark {
                                self.likeButton!.imageView!.image = UIImage(named:"heart-unselected-dark")
                            } else {
                                self.likeButton!.imageView!.image = UIImage(named:"heart-unselected")
                            }
                        } else {
                            self.likeButton!.imageView!.image = UIImage(named:"heart-selected")
                        }
                    } else {
                        self.db.collection("posts").document(self.postID).updateData(["likes": []])
                    }
                    
                }
            }
        } else {
            if globalDark {
                self.likeButton!.imageView!.image = UIImage(named:"heart-unselected-dark")
            } else {
                self.likeButton!.imageView!.image = UIImage(named:"heart-unselected")
            }
        }
        
    }

    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet var newCommentButton: CommentButton!
    
    @IBAction func linkButton(_ sender: Any) {
        if linkExists {
            
        }
    }
    var uid: String!
    
    
    var currentVC: ProfilePageViewController!
    
    var homeVC: HomeViewController!
    
    var like: Bool?
    
    var rowID: Int!
    
    var linkExists: Bool = false
    var links: [URL] = Array<URL>()
    var linkNames: [String] = Array<String>()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var reloaded: Bool = false
    var imgCount: Int = 0
    var imgHeight: CGFloat = 0
    
    var darkMode: Bool!
    
    var postID: String!
    
    var indexPath: IndexPath!
    
    var updateHeight: UpdateHeight!
    
    var commentsVC: CommentsTableViewController!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func label(_ label: UILabel, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
        
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        let likeDocumentRef = db.collection("posts").document(postID)
        likeDocumentRef.getDocument{ (document, error) in
            
            if let document = document, document.exists {
                let map = document.data()!
                if map["likes"] != nil {
                    var likes = map["likes"] as! [String]
                    if likes.contains(Auth.auth().currentUser!.uid) {
                        print("-1")
                        let likeRef = self.db.collection("posts").document(self.postID!)
                        
                        likeRef.updateData(["likes": FieldValue.arrayRemove([Auth.auth().currentUser!.uid])])
                        if globalDark {
                            self.likeButton!.imageView!.image = UIImage(named:"heart-unselected-dark")
                        } else {
                            self.likeButton!.imageView!.image = UIImage(named:"heart-unselected")
                        }
                        let likenum = Int(self.likeCount!.text!)
                        self.likeCount!.text = "\(likenum! - 1)"
                    } else {
                        print("+1")
                        let likeRef = self.db.collection("posts").document(self.postID!)
                        
                        likeRef.updateData(["likes": FieldValue.arrayUnion([Auth.auth().currentUser!.uid])])
                        self.likeButton!.imageView!.image = UIImage(named:"heart-selected")
                        let likenum = Int(self.likeCount!.text!)
                        self.likeCount!.text = "\(likenum! + 1)"
                        
                    }
                } else {
                    self.db.collection("posts").document(self.postID).updateData(["likes": []])
                }
                
            }
        }

    }
    
    func addPost(postID: String) {
        var addedHeight: CGFloat = 0
        self.postID = postID
        let userDocumentRef = db.collection("posts").document(postID)
        userDocumentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let map = document.data()!
                self.uid = map["uid"] as? String
                let userRef = self.db.collection("users").document(self.uid!)
                userRef.getDocument{ (userDocument, error) in
                    if let userDocument = userDocument, userDocument.exists {
                        let userMap = userDocument.data()!
                        self.userName!.text = userMap["name"] as! String
                        if userMap["image"] != nil {
                            let imageString = userMap["image"] as! String
                            self.userImage.load(url: URL(string: userMap["image"] as! String)!)
                        } else {
                            self.userImage!.image = UIImage(named: "blank-profile-picture")
                        }
                        
                    }
                }
                if map["likes"] != nil {
                    self.likeCount!.text = "\((map["likes"] as! [String]).count)"
                    let likes: [String] = (map["likes"] as! [String])
                    if likes.contains(Auth.auth().currentUser!.uid) {
                        self.like = true
                        self.likeButton!.imageView!.image = UIImage(named:"heart-selected")
                    } else {
                        self.like = false
                        if globalDark {
                            self.likeButton!.imageView!.image = UIImage(named:"heart-unselected-dark")
                        } else {
                            self.likeButton!.imageView!.image = UIImage(named:"heart-unselected")

                        }
                    }
                } else {
                    self.db.collection("posts").document(postID).updateData(["likes": []])
                }
                if map["comments"] != nil {
                    self.commentCount!.text = "\((map["comments"] as! [String]).count)"
                } else{
                    self.db.collection("posts").document(postID).updateData(["comments": []])
                }
                
                self.postText!.text = map["content"] as? String
                self.postDate!.text = map["date"] as? String
                
                let finalString: NSMutableAttributedString = NSMutableAttributedString(string: "")
                var skipNext: Bool = false
                let array = map["array"] as! [String]
                for index in 0..<array.count {
                    if array[index].contains("#doc#") {
                        skipNext = true
                        let str = array[index]
                        let start = str.index(str.startIndex, offsetBy: 5)
                        let end = str.index(str.endIndex, offsetBy: -5)
                        let range = start ..< end
                        let item = Int(String(str[range]))! + 1
//                            print("########")
//                            print(item)
//                            print("########")
                        let url = URL(string: map["\(item)"] as! String)
                        let fullString = NSAttributedString(string: array[index+1], attributes: [.link: url!.absoluteURL])
                        self.linkExists = true
                        self.links.append(url!)
                        self.linkNames.append(array[index+1])
                        finalString.append(fullString)
                    } else if array[index].contains("#img#") {
                        self.imgCount += 1
                        let str = array[index]
                        let start = str.index(str.startIndex, offsetBy: 5)
                        let end = str.index(str.endIndex, offsetBy: -5)
                        let range = start ..< end
                        let item = String(str[range])
                        let url = URL(string: map[item] as! String)
                        DispatchQueue.global().async {
                            guard let imageData = try? Data(contentsOf: url!) else { return }
                            
                            let image = UIImage(data: imageData)
                            self.imgHeight += image!.size.height
                            DispatchQueue.main.async {
                                let imageAttachment = NSTextAttachment()
                                imageAttachment.image = image!
                                let image1string = NSAttributedString(attachment: imageAttachment)
                                finalString.append(image1string)
                                self.postText!.attributedText = finalString
                                self.postText!.sizeToFit()
                                self.awakeFromNib()
                                addedHeight += image!.size.height
                                
//
                                self.imgCount -= 1
                                if self.imgCount == 0 {
                                    if !self.reloaded {
                                        self.reloaded = true
                                        let indexPath = IndexPath(row: self.rowID, section: 0)
                                        if self.currentVC != nil {
                                            self.currentVC.tableView.reloadRows(at: [indexPath], with: .none)
                                        } else if self.homeVC != nil{
                                            self.homeVC.tableView.reloadRows(at:[indexPath], with: .none)
                                        } else if self.commentsVC != nil {
                                            self.commentsVC.tableView.reloadRows(at:[indexPath], with: .none)
                                        }
//                                        self.updateHeight.updateHeight(indexPath: self.indexPath, height: self.imgHeight)
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    } else {
                        if !skipNext {
                            let fullString = NSAttributedString(string: array[index], attributes: nil)
                            finalString.append(fullString)
                        }
                        skipNext = false
                        
                    }

                }
                
                self.postText!.attributedText = finalString
                self.postText!.text = finalString.string
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
                var fetchedResults: [NSManagedObject]? = nil
                let predicate = NSPredicate(format: "email MATCHES '\(Auth.auth().currentUser!.email!)'")
                request.predicate = predicate
                
                do{
                    try fetchedResults = context.fetch(request) as? [NSManagedObject]
                } catch{
                    // error occurs
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
                let darkMode = (fetchedResults![0].value(forKey: "darkmode")) as! Bool
                if darkMode {
                    let string = finalString.string
                    let range = (string as NSString).range(of: string)
                    finalString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                    self.postText!.textColor = UIColor.white
                } else {
                    let string = finalString.string
                    let range = (string as NSString).range(of: string)
                    finalString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
                    self.postText!.textColor = UIColor.black
                }
                
                self.postText!.sizeToFit()
                let addedHeight = self.postText!.frame.size.height
//                self.updateHeight!.updateStringHeight(indexPath: self.indexPath, height: addedHeight)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func commentButtonPresseid(_ sender: Any) {
        newCommentButton!.postID = postID!
        if currentVC != nil {
            currentVC!.postIDSender = postID!
            currentVC.performSegue(withIdentifier: "Show Comments", sender: self)
        } else if homeVC != nil {
            homeVC!.postIDSender = postID!
            homeVC.performSegue(withIdentifier: "Show Comments", sender: self)
        }
    }
    

}
