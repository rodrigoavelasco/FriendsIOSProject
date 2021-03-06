//
//  ViewController.swift
//  Friends
//
//  Created by Rodrigo Velasco on 6/27/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import LocalAuthentication
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var currentUserButton: UIButton!
    var userEmail:String = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        overrideUserInterfaceStyle = .dark ill fix this when dark mode is implemented properly
        initializeTextFields()
        customizeButton(button: logInButton)
        customizeButton(button: signUpButton)
        customizeButton(button: createAccountButton)
        customizeButton(button: currentUserButton)
        self.confirmPasswordTextField.center.x += self.view.bounds.width
        self.fullNameTextField.center.x += self.view.bounds.width
        self.usernameTextField.center.x += self.view.bounds.width
        self.createAccountButton.center.x += self.view.bounds.width
        self.currentUserButton.center.x += self.view.bounds.width

    }
    
    override func viewDidAppear(_ animated: Bool) {
        userEmail = (Auth.auth().currentUser?.email) ?? ""
        print("here is the user email: \(userEmail)")
        if userEmail == ""{
            print("need to log in")
        } else{
            let biometricBoolean = getBiometricAuthenticationBoolean()
            if biometricBoolean{
                performBiometricAuthentication()
            }
        }
    }
    
    func getBiometricAuthenticationBoolean() -> Bool {
        let userID: String = (Auth.auth().currentUser?.uid) ?? ""
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
        return fetchedResults![0].value(forKey: "biometriclogin") as! Bool
    }
    
    func performBiometricAuthentication(){
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.performSegue(withIdentifier: "homeScreenSegueIdentifier", sender: nil)
                    } else {
                        // error
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

    @IBAction func logInButtonPressed(_ sender: Any) {
        
        if validLoginCredentials() {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
              user, error in
              if error != nil && user == nil {
                let credentialsAlert = UIAlertController(title: "Error loggin in \(String(describing: error))", message: "Please enter your credentials", preferredStyle: UIAlertController.Style.alert)
                credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(credentialsAlert, animated: true, completion: nil)
                print("error loggin in \(String(describing: error))")
              } else{
                    self.performSegue(withIdentifier: "homeScreenSegueIdentifier", sender: nil)
                    self.initializeTextFields()
                    print("signed In successfully ")
                }
            }
        } else if emailTextField.text == "" || emailTextField.text == "email"{
            let credentialsAlert = UIAlertController(title: "Email field empty", message: "Please enter your credentials", preferredStyle: UIAlertController.Style.alert)
            credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(credentialsAlert, animated: true, completion: nil)
        } else if passwordTextField.text != "" || passwordTextField.text != "password" {
            let credentialsAlert = UIAlertController(title: "Password field empty", message: "Please enter your credentials", preferredStyle: UIAlertController.Style.alert)
            credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(credentialsAlert, animated: true, completion: nil)
        }

    }
    
    func validLoginCredentials() -> Bool {
        return passwordTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "password" && emailTextField.text != "email"
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        prepareForSignUp()
        initializeSignUpTextFields()
        
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        if validUserCredentials(){
            Auth.auth().createUser(
                withEmail: emailTextField.text!,
                password: passwordTextField.text!){
                    user, error in
                    if error == nil {
                        Auth.auth().signIn(withEmail: self.emailTextField.text!,
                                           password: self.passwordTextField.text!)
                        self.performSegue(withIdentifier: "homeScreenSegueIdentifier", sender: nil)
                        let uid: String = Auth.auth().currentUser!.uid
                        self.db.collection("users").document(uid).setData([
                            "email": self.emailTextField.text!,
                            "username": self.usernameTextField.text!,
                            "name": self.fullNameTextField.text!
                        ], merge: true) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added")
                            }
                        }
                    }else {
                        print(error ?? "no error")
                        let credentialsAlert = UIAlertController(title: "Error creating account \(String(describing: error))", message: "Please enter your credentials", preferredStyle: UIAlertController.Style.alert)
                        credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(credentialsAlert, animated: true, completion: nil)
                        
                    }
            }
            
            
        }else if emailTextField.text! == "" || emailTextField.text == "email" {
            let credentialsAlert = UIAlertController(title: "Email field empty", message: "Please enter your credentials", preferredStyle: UIAlertController.Style.alert)
            credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            credentialsAlert.present(self, animated: true, completion: nil)
        }else if passwordTextField.text! == "" || passwordTextField.text == "password" {
            let credentialsAlert = UIAlertController(title: "Password field empty", message: "Please enter your credentials", preferredStyle: UIAlertController.Style.alert)
            credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            credentialsAlert.present(self, animated: true, completion: nil)
        }else if confirmPasswordTextField.text! == "" || confirmPasswordTextField.text == "confirm password" {
            let credentialsAlert = UIAlertController(title: "Confirm Password field empty", message: "Please enter your credentials", preferredStyle: UIAlertController.Style.alert)
            credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            credentialsAlert.present(self, animated: true, completion: nil)
        } else if confirmPasswordTextField.text! != passwordTextField.text!{
            let credentialsAlert = UIAlertController(title: "Passwords do not match", message: "Please make sure your passwords match", preferredStyle: UIAlertController.Style.alert)
            credentialsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            credentialsAlert.present(self, animated: true, completion: nil)
        }
    }
    
    func validUserCredentials() -> Bool{
        return passwordTextField.text! != "" && confirmPasswordTextField.text! != "" && confirmPasswordTextField.text! == passwordTextField.text! && emailTextField.text! != "" && emailTextField.text != "email" && passwordTextField.text != "password" && confirmPasswordTextField.text != "confirm password"
    }
    
    @IBAction func currentUserButtonPressed(_ sender: Any) {
        initializeTextFields()
        prepareForSignIn()
    }
    
    func prepareForSignUp(){
        UIView.animate(
            withDuration: 1.0,
            animations: {
                self.logInButton.center.x -= self.view.bounds.width
                self.signUpButton.center.x -= self.view.bounds.width
                self.confirmPasswordTextField.center.x -= self.view.bounds.width
                self.usernameTextField.center.x -= self.view.bounds.width
                self.createAccountButton.center.x -= self.view.bounds.width
                self.currentUserButton.center.x -= self.view.bounds.width
                self.fullNameTextField.center.x -= self.view.bounds.width
        }
        )
    }
    
    func prepareForSignIn(){
        UIView.animate(
            withDuration: 1.0,
            animations: {
                self.logInButton.center.x += self.view.bounds.width
                self.signUpButton.center.x += self.view.bounds.width
                self.confirmPasswordTextField.center.x += self.view.bounds.width
                self.usernameTextField.center.x += self.view.bounds.width
                self.createAccountButton.center.x += self.view.bounds.width
                self.currentUserButton.center.x += self.view.bounds.width
                self.fullNameTextField.center.x += self.view.bounds.width
        }
        )
    }
    
    func customizeButton(button:UIButton){
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray{
            if (textField.text == "password" || textField.text == "confirm password"){
                textField.isSecureTextEntry = true
            }
            textField.text = nil
            textField.textColor = .label
        }
    }
    
    func initializeTextFields(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.text = "password"
        passwordTextField.textColor = UIColor.lightGray
        passwordTextField.isSecureTextEntry = false
        emailTextField.text = "email"
        emailTextField.textColor = UIColor.lightGray
    }
    
    func initializeSignUpTextFields(){
        fullNameTextField.delegate = self
        confirmPasswordTextField.delegate = self
        usernameTextField.delegate = self
        confirmPasswordTextField.text = "confirm password"
        confirmPasswordTextField.textColor = UIColor.lightGray
        confirmPasswordTextField.isSecureTextEntry = false
        fullNameTextField.text = "full name"
        fullNameTextField.textColor = UIColor.lightGray
        usernameTextField.text = "username"
        usernameTextField.textColor = UIColor.lightGray
        
    }
    
    // code to enable tapping on the background to remove software keyboard
    private func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}


