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
    
    @IBAction func linkButton(_ sender: Any) {
        if linkExists {
            
        }
    }
    var uid: String!
    
    var currentVC: ProfilePageViewController!
    
    var like: Bool?
    
    var rowID: Int!
    
    var linkExists: Bool = false
    var links: [URL] = Array<URL>()
    var linkNames: [String] = Array<String>()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var reloaded: Bool = false
    var imgCount: Int = 0
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func label(_ label: UILabel, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
        
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
                
                let finalString: NSMutableAttributedString = NSMutableAttributedString(string: "")
                var skipNext: Bool = false
                let array = map["array"] as! [String]
                for index in 0..<array.count {
                    if !skipNext {
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
                                DispatchQueue.main.async {
                                    let imageAttachment = NSTextAttachment()
                                    imageAttachment.image = image!
                                    let image1string = NSAttributedString(attachment: imageAttachment)
                                    finalString.append(image1string)
                                    self.postText!.attributedText = finalString
                                    self.postText!.sizeToFit()
//
                                    self.imgCount -= 1
                                    if self.imgCount == 0 {
                                        if !self.reloaded {
                                            self.reloaded = true
                                            let indexPath = IndexPath(row: self.rowID, section: 0)
                                            self.currentVC.tableView.reloadRows(at: [indexPath], with: .none
                                            )
                                        }
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
                    
//                    let tempItem: NSAttributedString = NSAttributedString(string: item.replacingOccurrences(of: "\\n", with: "\n"))
//
//                    finalString.append(tempItem)
                }
                
                
                
                
                self.postText!.attributedText = finalString
//                self.postText!.lineBreakMode = NSLineBreakMode.byWordWrapping
//                self.postText!.numberOfLines = 0
//                let tempLabel: UILabel = self.postText!
//                tempLabel.sizeToFit()
//                self.postText!.fr
//                CGSize = CGSize(
                self.postText!.sizeToFit()
                
                let oldFont = self.postText!.font!
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
}
