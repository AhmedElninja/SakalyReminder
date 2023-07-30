//
//  AppDelegate.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 21/06/2023.
//

import UIKit
import Firebase
import FirebaseFirestore




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //Mark: - Properties.
    var window: UIWindow?
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
    
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        handleRoot()
        
        return true
    }
    // MARK: - Public Methods.
    public func goToSignInVC() {
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        let navigationController = UINavigationController.init(rootViewController: signInVC)
        self.window?.rootViewController = navigationController
    }
    public func goToTaskVC() {
        let taskVC: TaskVC = mainStoryboard.instantiateViewController(withIdentifier: Views.taskVC) as! TaskVC
        let navigationController = UINavigationController.init(rootViewController: taskVC)
        self.window?.rootViewController = navigationController
    }
}
// MARK: - Private Methods.
extension AppDelegate {
    private func handleRoot() {
        if let userLoggedIn = UserDefaults.standard.object(forKey: UserDefultKeys.isUserloggedIn) as? Bool {
            if userLoggedIn {
                   goToTaskVC()
               } else {
                   goToSignInVC()
               }
           } else {
               goToSignInVC()
           }
        }
    }





