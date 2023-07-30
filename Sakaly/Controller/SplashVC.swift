//
//  SplashVC.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 25/06/2023.
//

import UIKit

class SplashVC: UIViewController {

    //Mark: - Outlets.
    @IBOutlet weak var splshImage: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    
    //Mark: - LifeCycle Methods.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLabel()
        navigateToSignUpVC()
        
    }
    //Mark: - Methods
    func animateLabel() {
        appNameLabel.text = ""
        var charIndex = 0.0
        let titleText = "Sakaly"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.appNameLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
    }
    func navigateToSignUpVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
            let signUpVC: SignUpVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signUpVC) as! SignUpVC
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}
