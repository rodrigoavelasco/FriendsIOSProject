//
//  ViewController.swift
//  Friends
//
//  Created by Rodrigo Velasco on 6/27/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeTextFields()
        customizeLogInButton()
    }

    @IBAction func logInButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeScreenIdentifier", sender: nil)
        initializeTextFields()
    }
    
    func customizeLogInButton(){
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.backgroundColor = UIColor.blue
        logInButton.layer.cornerRadius = 10
        logInButton.layer.borderWidth = 1.0
        logInButton.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray{
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    
    func initializeTextFields(){
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.text = "password"
        passwordTextField.textColor = UIColor.lightGray
        userNameTextField.text = "username"
        userNameTextField.textColor = UIColor.lightGray
        
    }

}

