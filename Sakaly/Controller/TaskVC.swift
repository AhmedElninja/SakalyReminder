//
//  TaskVC.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 24/06/2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore


class TaskVC: UIViewController, PopUpVCDelegate {
    
    //Mark: - Outlets.
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var taskTableView: UITableView!
    
    
    //Mark: - Propreties.
    var tasks: [TasksData] = []
    let db = Firestore.firestore()
    

    //Mark: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        if let userName = UserDefaults.standard.string(forKey: UserDefultKeys.userName) {
            navigationController?.navigationBar.topItem?.title = userName
        }
        navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationItem.setHidesBackButton(true, animated: false)
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        fetchTasks()
    }
    
    @IBAction func addTaskBtnTapped(_ sender: UIBarButtonItem) {
        showPopUp()
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: UserDefultKeys.isUserloggedIn)
        FireBaseManger.shared.logOut()
        goToSignInVC()
    }
}

//Mark: - UITableViewDataSource
extension TaskVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configureCell(task: task)
        cell.delegate = self
        return cell
    }
}
//Mark: - UITableViewDelegate
extension TaskVC: UITableViewDelegate, TaskTableViewCellDelegate {
    func deleteButtonTapped(for cell: TaskTableViewCell) {
        guard let indexPath = taskTableView.indexPath(for: cell) else {
            return
        }
        let task = tasks[indexPath.row]
        
        tasks.remove(at: indexPath.row)
        taskTableView.deleteRows(at: [indexPath], with: .automatic)
        
        FireBaseManger.shared.deleteTaskFromFirestore(task: task)  { [weak self] success in
            guard let self = self else { return }
            
            if success {
                
            } else {
                print("Data didn't deleted")
            }
        }
    }
    
    func didSaveTask(_ task: TasksData) {
        tasks.append(task)
        taskTableView.reloadData()
    }
}

//Mark: - extension TaskVC.
extension TaskVC {
    func goToSignInVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        self.navigationController?.viewControllers = [signInVC, self]
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc private func showPopUp() {
        let popUpVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(identifier: "PopUpVC") as! PopUpVC
        popUpVC.tasks = tasks
        popUpVC.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.bounds
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)
    }
    func fetchTasks() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            tasks = []
            taskTableView.reloadData()
            return
        }
        
        FireBaseManger.shared.loadData { [weak self] tasks in
            guard let self = self else { return }
            
            self.tasks = tasks
            self.taskTableView.reloadData()
        }
    }
}
