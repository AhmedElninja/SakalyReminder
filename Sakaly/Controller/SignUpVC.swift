//
//  ViewController.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 21/06/2023.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    //Mark: - Outlets.
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var userNameIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var passworedIcon: UIImageView!
    
    //Mark: - Lifeycycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    //Mark: - Actions.
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        if isDataEntered() {
            if isValidData() {
                let user = Users(userName: userNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
                FireBaseManger.shared.createAccount(user: user)
                goToSignInVC()
            }
        }
    }
    
   @IBAction func signInBtnTapped(_ sender: UIButton) {
       goToSignInVC()       
    }
}

//Mark: - extension SignUpVC.
extension SignUpVC {
    private func goToSignInVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func isDataEntered() -> Bool {
        guard userNameTextField.text != "" else {
            showAler(message: "Please Enter UserName")
            return false
        }
        guard emailTextField.text != "" else {
            showAler(message: "Please enter Email")
            return false
        }
        guard passwordTextField.text != "" else {
            showAler(message: "Please enter passwored")
            return false
        }
        return true
    }
    private func isValidData() -> Bool {
        guard Validator.shared().isValidEmail(email: emailTextField.text!) else {
            showAler(message: "Please enter a Valid Email Address. Example: mail@Example.com")
            return false
        }
        guard Validator.shared().isValidPassword(password: passwordTextField.text!) else {
            showAler(message: "Please enter Valid Passwored. Must contain At least: one Capital letter, one small letter, one Number and one spesific character, it must be at least 8 character Example: Aa@12345")
            return false
        }
        return true
    }
}
