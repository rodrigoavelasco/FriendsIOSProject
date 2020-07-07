//
//  UserProfileTableViewCell.swift
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


class UserProfileTableViewCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var imageSetView: UIView!
    @IBOutlet weak var imageTapToSet: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    
    var datePicker: UIDatePicker!
    
    var currentVC: UIViewController!
    
    
    
    var editName: Bool = false
    var editUsername: Bool = false
    var editImage: Bool = false
    var editBirthday: Bool = false
    var editEmail: Bool = false
    var editPhone: Bool = false
    var editLocation: Bool = false
    
    var uid: String!
    var personal: Bool = false
    
    let db = Firestore.firestore()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        // set text delegates
        nameText.delegate = self
        usernameText.delegate = self
        emailText.delegate = self
        phoneText.delegate = self
        locationText.delegate = self
        	
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        if personal {
            if editName {
                name!.text = nameText!.text!
                name!.isHidden = false
                nameText!.isHidden = true
                db.collection("users").document(uid!).updateData(["name": name!.text!]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
                editName = false
            }
            if editUsername {
                userName!.text = usernameText!.text!
                userName!.isHidden = false
                usernameText!.isHidden = true
                db.collection("users").document(uid!).updateData(
                ["username": userName!.text!]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document succesfully updated")
                    }
                }
                
                editUsername = false
            }
            if editImage {
                
                editImage = false
            }
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func checkPersonal() {
        if Auth.auth().currentUser!.uid == uid! {
            personal = true
        }
    }
    
    func setBirthday(changed: Bool) {
        birthday!.isHidden = false
        editBirthday = false
    }
    
    
    @IBAction func namePressed(_ sender: Any) {
        checkPersonal()
        if personal {
            editName = true
            name!.isHidden = true
            nameText!.text = name != nil ? name!.text! : ""
            nameText!.isHidden = false
            nameText!.becomeFirstResponder()
        }
    }
    
    @IBAction func usernamePressed(_ sender: Any) {
        checkPersonal()
        if personal {
            editUsername = true
            userName!.isHidden = true
            usernameText!.text = userName != nil ? userName!.text! : ""
            usernameText!.isHidden = false
            usernameText!.becomeFirstResponder()
        }
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        checkPersonal()
        if personal {
            editImage = true
        }
    }
    
    @IBAction func birthdayPressed(_ sender: Any) {
        checkPersonal()
        if personal {
            editBirthday = true
            birthday!.isHidden = true
            let dateChooserAlert = UIAlertController(title: "Choose your birthday", message: nil, preferredStyle: .actionSheet)
            datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePicker.Mode.date

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            if (birthday != nil) {
                datePicker.date = dateFormatter.date(from: birthday!.text!)!
            }
            dateChooserAlert.view.addSubview(datePicker)
            dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                self.birthday!.text! = dateFormatter.string(from: self.datePicker!.date)
                print(dateFormatter.string(from: self.datePicker!.date))
                self.setBirthday(changed: true)
            }))
            dateChooserAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                
                self.setBirthday(changed: false)
            }))
            let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
            dateChooserAlert.view.addConstraint(height)
            currentVC?.present(dateChooserAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func emailPressed(_ sender: Any) {
        checkPersonal()
    }
    
    @IBAction func phonePressed(_ sender: Any) {
        checkPersonal()
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        checkPersonal()
    }
    
}
