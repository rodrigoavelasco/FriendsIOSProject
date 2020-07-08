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
import FirebaseStorage
import FirebaseFirestoreSwift
import CoreLocation


class UserProfileTableViewCell: UITableViewCell, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    var uid: String!
    var imageUrl: String!
    var currentLocation: String!
    var locationManager = CLLocationManager()
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    
    // bools
    var editName: Bool = false
    var editUsername: Bool = false
    var editImage: Bool = false
    var editBirthday: Bool = false
    var editEmail: Bool = false
    var editPhone: Bool = false
    var editLocation: Bool = false
    var personal: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        // set text delegates
        nameText.delegate = self
        usernameText.delegate = self
        emailText.delegate = self
        phoneText.delegate = self
        locationText.delegate = self
        
        locationManager.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        closeTexts()
        return true
    }
    
    func closeTexts () {
        if personal {
            let userRef = db.collection("users").document(uid!)
            if editName {
                name!.text = nameText!.text!
                name!.isHidden = false
                nameText!.isHidden = true
                userRef.updateData(["name": name!.text!]) { err in
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
                userRef.updateData(
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
                userRef.updateData(
                ["image_url": self.imageUrl ?? ""]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document succesfully updated")
                    }
                }
                editImage = false
            }
            if editEmail {
                Auth.auth().currentUser?.updateEmail(to: emailText!.text!) {
                    (error) in
                    let incorrectEmailAlert = UIAlertController(title: "Email address error", message: "You must choose a different email address", preferredStyle: .alert)
                    incorrectEmailAlert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: {
                        action in
                        self.emailText!.becomeFirstResponder()
                    }))
                    if self.emailText!.text! != self.email!.text!{
                        self.currentVC?.present(incorrectEmailAlert, animated: true, completion: nil)
                    }
                    self.emailText!.text! = Auth.auth().currentUser!.email!
                }
                email!.text! = emailText!.text!
                userRef.updateData([
                    "email": email!.text!]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                }
                emailText!.isHidden = true
                email!.isHidden = false
                editEmail = false
            }
            if editPhone {
                phone!.text! = phoneText!.text!
                phone!.isHidden = false
                phoneText!.isHidden = true
                userRef.updateData(["phone": phone!.text!]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                editPhone = false
            }
            if editLocation {
                location!.text! = locationText!.text!
                locationText!.isHidden = true
                location!.isHidden = false
                userRef.updateData(["location": location!.text!]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                editLocation = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func checkPersonal() {
        if !personal && Auth.auth().currentUser!.uid == uid! {
            personal = true
        }
    }
    
    func setBirthday(changed: Bool) {
        if changed {
            db.collection("users").document(uid!).updateData(["birthday": birthday!.text!]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }

        }
        editBirthday = false
    }
    
    @IBAction func cancelPhone(sender: UIBarButtonItem) {
        phoneText!.text = phone!.text!
        phoneText!.resignFirstResponder()
        phoneText!.isHidden = true
        phone!.isHidden = false
        editPhone = false
    }
    
    @IBAction func donePhone(sender: UIBarButtonItem) {
        phone!.text! = phoneText!.text!
        phone!.isHidden = false
        phoneText!.isHidden = true
        db.collection("users").document(uid!).updateData(["phone": phone!.text!]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        phoneText!.resignFirstResponder()
        editPhone = false
    }
    
    
    @IBAction func namePressed(_ sender: Any) {
        closeTexts()
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
        closeTexts()
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
        closeTexts()
        checkPersonal()
        if personal {
            editImage = true
            userImage.contentMode = .scaleAspectFit
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            picker.present(picker, animated: true)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                return
            }
            guard let imageData = image.pngData() else {
                return
            }
            
        let name = self.userName.text!
        let ref = self.storageRef.child("images/" + name + ".png")
        ref.putData(imageData,
                              metadata: nil,
                              completion: {_, error in
                                guard error == nil else {
                                    print("Failed to upoad")
                                    return
                                }
                                ref.downloadURL(completion: {
                                    url, error in guard let url = url, error == nil else {
                                        return
                                    }
                                    let urlString = url.absoluteString
                                    print("Download URL: \(urlString)")
                                    self.imageUrl = urlString
//                                    UserDefaults.standard.set(urlString, forKey: "url")
                                })})
            // upload image data
            // get download
            // save download url to userDefaults
        
        //        guard let urlString = "" as? String, let url = URL(string: urlString) else {
        //            return
        //        }
        //
        //        URLSession.shared.dataTask(with: url, completionHandler: {
        //            data, _, error in
        //            guard let data = data, error == nil else {
        //                return
        //            }
        //            DispatchQueue.main.async {
        //                let image = UIImage(data: data)
        //                self.userImage.image = image
        //            }
        //        })
        //
        //        TASK.RESUME()
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
    
    @IBAction func birthdayPressed(_ sender: Any) {
        closeTexts()
        checkPersonal()
        if personal {
            editBirthday = true
            let dateChooserAlert = UIAlertController(title: "Choose your birthday", message: nil, preferredStyle: .actionSheet)
            datePicker = UIDatePicker(frame: CGRect(x:35, y: 20, width: 320, height: 220))
            datePicker.datePickerMode = UIDatePicker.Mode.date

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            if (birthday != nil && birthday!.text != "Tap to set") {
                datePicker!.date = dateFormatter.date(from: birthday!.text!)!
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
            let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 350)
            dateChooserAlert.view.addConstraint(height)
            currentVC?.present(dateChooserAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func emailPressed(_ sender: Any) {
        closeTexts()
        checkPersonal()
        if personal {
            editEmail = true
            email!.isHidden = true
            emailText!.text = email != nil && email!.text! != "Tap to set" ? email!.text! : ""
            emailText!.isHidden = false
            emailText!.becomeFirstResponder()
        }
    }
    
    @IBAction func phonePressed(_ sender: Any) {
        closeTexts()
        checkPersonal()
        if personal {
            editPhone = true
            phone!.isHidden = true
            phoneText!.text = phone != nil && phone!.text! != "Tap to set" ? phone!.text! : ""
            phoneText!.isHidden = false
            let numberToolbar: UIToolbar = UIToolbar()
            numberToolbar.barStyle = UIBarStyle.default
            numberToolbar.items = [
                UIBarButtonItem(title:"Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPhone(sender:))),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Apply", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePhone(sender:)))]
            numberToolbar.sizeToFit()
            phoneText!.inputAccessoryView = numberToolbar
            phoneText!.becomeFirstResponder()
        } else {
            if phone != nil && phone!.text! != "" && phone!.text! != "Tap to set" {
                if let url = URL(string: "tel://\(phone!.text!)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        closeTexts()
        checkPersonal()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if personal {
            let locationAlert = UIAlertController(title: "Select Location Method", message: "Do you wish to have the app determine your location for you?", preferredStyle: UIAlertController.Style.alert)
            locationAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
                self.locationManager.requestLocation()
            }))
            locationAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { action in
                self.editLocation = true
                self.location!.isHidden = true
                self.locationText!.text = self.location != nil && self.location!.text! != "Tap to set" ? self.location!.text! : ""
                self.locationText!.isHidden = false
                self.locationText!.becomeFirstResponder()
            }))

            currentVC?.present(locationAlert, animated: true, completion: nil)
        } else {
            let targetURL = URL(string: "http://maps.apple.com/?q=\"\(locationText!)")!
            let isAvailable = UIApplication.shared.canOpenURL(targetURL)
            if (isAvailable) {
                UIApplication.shared.open(targetURL)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location manager")
        if personal {
            let locValue: CLLocation = locations.first!
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(locValue, preferredLocale: nil , completionHandler: { (placemarks, _) -> Void in
                placemarks?.forEach { (placemark) in
                    self.location!.text! = "\(placemark.locality!), \(placemark.administrativeArea!)"
                    self.db.collection("users").document(self.uid!).updateData(["location": self.location!.text!]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            })
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager,
    didFailWithError error: Error) {
        print(error)
    }
    
    
}

//extension UserProfileTableViewCell: CLLocationManagerDelegate {
//    
//    // called when the authorization status is changed for the core location permission
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("location manager authorization status changed")
//    }
//    
////    func locationManager(_ manager: CLLocationManager, didUpdateLocatinos locations: [CLLocation]) {
////        print("location manager")
////        if personal {
////            let locValue: CLLocation = manager.location!
////            let geoCoder = CLGeocoder()
////            geoCoder.reverseGeocodeLocation(locValue, completionHandler: { (placemarks, _) -> Void in
////                placemarks?.forEach { (placemark) in
////
////                    if let city = placemark.locality, let subCity = placemark.subLocality, let country = placemark.country {
////                        self.currentLocation = "\(subCity) \(city), \(country)"
////                        print(city, subCity, country)
////                    }
////                }
////            })
////        }
////
////
////    }
//    
//    
//}
