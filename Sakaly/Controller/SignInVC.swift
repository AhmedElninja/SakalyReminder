//
//  SignInVC.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 23/06/2023.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import FirebaseFirestore

class SignInVC: UIViewController {
    
    //mark: - Outlets.
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var passworedIcon: UIImageView!
    
    
    //Mark: - LifeCycle Method.
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let def = UserDefaults.standard
        def.setValue(true, forKey: UserDefultKeys.isUserloggedIn)

    }
    
    //Mark: - Action.
    @IBAction func logInBtnTapped(_ sender: UIButton) {
        if isDataEntered() {
            let user = Users(email: emailTextField.text!, password: passwordTextField.text!)
            FireBaseManger.shared.checkData(user: user)
                signIn()
                goToTasksVC()
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        goToSignUpVC()
    }
}

//Mark: - extension SignInVC.
extension SignInVC {
    private func goToSignUpVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let signUpVC: SignUpVC = mainStoryboard.instantiateViewController(identifier: Views.signUpVC) as! SignUpVC
        self.navigationController?.viewControllers = [signUpVC, self]
        self.navigationController?.popViewController(animated: true)
    }
    
    private func goToTasksVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let taskVC: TaskVC = mainStoryboard.instantiateViewController(withIdentifier: Views.taskVC) as! TaskVC
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    private func isDataEntered() -> Bool {
        guard emailTextField.text != "" else {
            showAler(message: "Please Enter Email")
            return false
        }
        guard passwordTextField.text != "" else {
            showAler(message: "Please Enter Password")
            return false
        }
        return true
    }
    
    private func signIn() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.notifyTaskVC()
            }
        }
    }
    private func notifyTaskVC() {
        guard let taskVC = self.navigationController?.viewControllers.first(where: { $0 is TaskVC }) as? TaskVC else {
            return
        }
        taskVC.fetchTasks()
    }
}


 

