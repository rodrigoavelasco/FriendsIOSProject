//
//  NewPostTableViewController.swift
//  Friends
//
//  Created by Andrew Kim on 7/7/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import CoreData
import FirebaseFirestoreSwift
import FirebaseFirestore

class NewPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var myTextView: UITextView!
//    var imageView:UIImageView!
    let picker = UIImagePickerController()
    
    var kbHeight: CGFloat = 0
    
    var curIndexPath: IndexPath!
    
    var postCell: NewPostTableViewCell!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                AVCaptureDevice.requestAccess(
                for: .video) {
                    accessGranted in
                    guard accessGranted == true else { return }
                }
            case .authorized:
                break
            default:
                print("Access denied")
                return
            }
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
        
            present(picker, animated: true, completion: nil)
            
        } else {
            // no camera is available, pop up an alert
            let alertVC = UIAlertController(
                title: "No camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        picker.allowsEditing = false    // whole pic, as is, not any edited version
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // info contains a "dictionary" of information about the selected media, including:
        // - metadata
        // - a user-edited image (if you had allowed editing earlier)
        
        // get the selected picture:  this is the only part of info that we care about here
        // original image, edited image, filesystem URL (for movie), relevant editing info
        
        let chosenImage = info[.originalImage] as! UIImage
        
//        // shrink it tp a visible size
//        imageView.contentMode = .scaleAspectFit
//
//        // put the picture in the imageView
//        imageView.image = chosenImage
        
        let fullString = NSMutableAttributedString(string: "Start of text")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = chosenImage
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: "End of text"))
        let combination = NSMutableAttributedString()
        combination.append(myTextView.attributedText as! NSMutableAttributedString)
        combination.append(fullString)
        myTextView.attributedText = combination
        
        // dismiss the popover
        dismiss(animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // code to enable tapping on the background to remove software keyboard
    private func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! NewPostTableViewCell

        // Configure the cell...
        cell.vc = self
//        print (cell.postContent!.text!)
//        print("tell")
        curIndexPath = indexPath
        postCell = cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height - (self.tabBarController?.tabBar.frame.height)! -  kbHeight
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc internal func keyboardWillShow(_ notification: Notification?) -> Void {
        var _kbSize:CGSize!
        
        if let info = notification?.userInfo {
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                let screenSize = UIScreen.main.bounds
                
                let intersectRect = kbFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                print("Your Keyboard Size \(_kbSize!)")
                kbHeight = _kbSize.height
//                if postCell != nil {
//                    postCell!.kbHeight = kbHeight
//                    var pictureFrame = postCell.pictureButton.frame
//                    var cameraFrame = postCell.cameraButton.frame
//                    var fileFrame = postCell.fileButton.frame
//                    pictureFrame.origin.y = pictureFrame.origin.y - kbHeight
//                    cameraFrame.origin.y = cameraFrame.origin.y - kbHeight
//                    fileFrame.origin.y = fileFrame.origin.y - kbHeight
//                }
            }
        }
    }
    
//    func keyboardwillHide(_ notification: Notification) {
//        
//    }
}