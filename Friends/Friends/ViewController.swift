//
//  ViewController.swift
//  Friends
//
//  Created by Rodrigo Velasco on 6/27/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customizeLogInButton()
        userNameTextField.text = "username"
        userNameTextField.layer.borderColor = UIColor.black.cgColor
    }

    func customizeLogInButton(){
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.backgroundColor = UIColor.blue
        logInButton.layer.cornerRadius = 10
        logInButton.layer.borderWidth = 1.0
        logInButton.layer.borderColor = UIColor.darkGray.cgColor
        
    }

}

