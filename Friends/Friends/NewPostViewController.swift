//
//  NewPostViewController.swift
//  Friends
//
//  Created by Andrew Kim on 7/5/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import AVFoundation

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var myTextView: UITextView!
//    var imageView:UIImageView!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
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
        }    }
    
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

}
