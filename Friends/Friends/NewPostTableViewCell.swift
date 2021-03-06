//
//  NewPostTableViewCell.swift
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

class NewPostTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        picker.delegate = self
    }


    var vc: NewPostTableViewController!
    var hvc: HomeViewController!
    
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    
    var files: [String] = Array<String>()
    var pictures: [String] = Array<String>()
    
    var kbHeight: CGFloat!
    
    let picker = UIImagePickerController()

    var docPicker : UIDocumentPickerViewController!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        postContent.becomeFirstResponder()
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
            postContent!.textColor = UIColor.white
        } else {
            postContent!.textColor = UIColor.black
        }
//        postContent!.textColor = UIColor.white
    }

    @IBAction func pictureButtonPressed(_ sender: Any) {
        picker.allowsEditing = false    // whole pic, as is, not any edited version
        picker.sourceType = .photoLibrary
        vc.present(picker, animated: true, completion: nil)
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
//                print("Access denied")
                return
            }
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
        
            vc!.present(picker, animated: true, completion: nil)
            
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
            vc!.present(alertVC, animated: true, completion: nil)
        }
        postContent.becomeFirstResponder()
    }
    @IBAction func fileButtonPressed(_ sender: Any) {
        showDocumentPicker()
        postContent.becomeFirstResponder()
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.last else {
            return
        }
        print("import result : \(myURL.relativeString)")
        
        let oldFont = postContent.font!
        
        let filename: String = ((myURL.relativeString as NSString).lastPathComponent).removingPercentEncoding!.html2String
        
        var fileData: Data!
        do {
            fileData = try Data(contentsOf: myURL)
        } catch {
            print(error)
            print("couldn't open file")
            return
        }
        
        let fullString = NSMutableAttributedString(string: filename, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), .link: myURL.absoluteURL])

        let combination = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)])
        combination.append(postContent.attributedText!.mutableCopy() as! NSMutableAttributedString)
        combination.append(fullString)
        combination.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 22), range: NSRange())
        
//        let documentAttachment = NSTextAttachment(data: fileData!, ofType: nil)
//        let documentString = NSAttributedString(attachment: documentAttachment)
//            combination.append(documentString)

        
        
        combination.append(NSAttributedString(string:"\n", attributes: nil))
        postContent.attributedText = combination
        
        
        postContent.font = oldFont
    }
    


    
//    func decodeString(encodedString:String) -> NSAttributedString?
//    {
//        let encodedData = encodedString.data(using: String.Encoding.utf8)!
//        do {
//
//            return try NSAttributedString(data: encodedData, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            return nil
//        }
//    }


//    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        vc.present(documentPicker, animated: true, completion: nil)
//    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
//        vc.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        // info contains a "dictionary" of information about the selected media, including:
        // - metadata
        // - a user-edited image (if you had allowed editing earlier)
        
        // get the selected picture:  this is the only part of info that we care about here
        // original image, edited image, filesystem URL (for movie), relevant editing info
        let oldFont = postContent.font!
        var chosenImage = info[.originalImage] as! UIImage
        
//        // shrink it tp a visible size
//        imageView.contentMode = .scaleAspectFit
//
//        // put the picture in the imageView
//        imageView.image = chosenImage
        let origWidthRatio:CGFloat = UIScreen.main.bounds.size.width / chosenImage.size.width
        
        let size = chosenImage.size
        let finalWidth = size.width * origWidthRatio
        let finalHeight = size.height * origWidthRatio
        let newSize: CGSize = CGSize(width: finalWidth, height: finalHeight)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        chosenImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        chosenImage = newImage!
            
        let fullString = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)])
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = chosenImage
    
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]))
        let combination = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)])
        combination.append(postContent.attributedText!.mutableCopy() as! NSMutableAttributedString)
        combination.append(fullString)
        combination.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 22), range: NSRange())
        combination.append(NSAttributedString(string: "\n", attributes: nil))
        postContent.attributedText = combination
        
        // dismiss the popover
        vc.dismiss(animated: true, completion: nil)
        postContent.font = oldFont
        postContent.becomeFirstResponder()
    }
    
    func showDocumentPicker() {
        let documentTypes = ["public.image", "com.adobe.pdf"]
        
        docPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: UIDocumentPickerMode.import)
        
        docPicker.delegate = self
        docPicker.modalPresentationStyle = .formSheet
        
//        let window = UIWindow(frame: UIScreen.main.bounds)
        vc.present(docPicker, animated: false, completion: nil)
        let oldFont = postContent.font!
        
        postContent.font = oldFont
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
