//
//  ChangePasswordViewController.swift
//  Friends
//
//  Created by Rodrigo Velasco on 7/9/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var confirmChangeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isDarkMode() {
            overrideUserInterfaceStyle = .dark
        } else{
            overrideUserInterfaceStyle = .light
        }
        initializeTextFields()
        customizeButtonBlue(button: confirmChangeButton)
    }
    
    func initializeTextFields(){
        newPasswordTextField.delegate = self
        confirmNewPasswordTextField.delegate = self
        newPasswordTextField.text = "Enter New Password"
        newPasswordTextField.textColor = UIColor.lightGray
        confirmNewPasswordTextField.text = "Confirm New Password"
        confirmNewPasswordTextField.textColor = UIColor.lightGray
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray{
            textField.text = nil
            textField.textColor = .label
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        if validPassword(){
            Auth.auth().currentUser?.updatePassword(to: newPasswordTextField.text!, completion: nil)
            let credentialsAlert = UIAlertController(title: "Updated Password", message: "Successfully", preferredStyle: UIAlertController.Style.alert)
            credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(credentialsAlert, animated: true, completion: nil)
        }else{
            let credentialsAlert = UIAlertController(title: "Invalid Passwords", message: "Please check your passwords match or that they are not empty.", preferredStyle: UIAlertController.Style.alert)
            credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(credentialsAlert, animated: true, completion: nil)
        }
    }
    
    func validPassword() -> Bool {
        return newPasswordTextField.text != "" && confirmNewPasswordTextField.text != "" && newPasswordTextField.text != "Enter New Password" && confirmNewPasswordTextField.text != "Confirm New Password" && newPasswordTextField.text == confirmNewPasswordTextField.text
    }
    
    func customizeButtonBlue(button:UIButton){
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func isDarkMode() -> Bool {
        let userID = (Auth.auth().currentUser?.uid) ?? ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        var fetchedResults: [NSManagedObject]? = nil
        let predicate = NSPredicate(format: "uid MATCHES '\(userID)'")
        request.predicate = predicate
        
        do{
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch{
            // error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return fetchedResults![0].value(forKey: "darkmode") as! Bool
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
