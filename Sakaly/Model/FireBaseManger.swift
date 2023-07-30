//
//  FireBaseManger.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 25/06/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FireBaseManger: UIViewController {
    
    //Mark: - Singleton
    static let shared = FireBaseManger()
    
    //Mark: - Properties
    let db = Firestore.firestore()
    var tasks = [TasksData]()
    
    //Mark: - Methods
    public func createAccount(user: Users) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Created")
            }
        }
        UserDefaults.standard.set(user.userName, forKey: "userName")
    }
    
    public func checkData(user: Users) {
        let usersRef = Firestore.firestore().collection("users").whereField("email", isEqualTo: user.email)
        let query = usersRef.whereField("email", isEqualTo: user.email
        ).limit(to: 1)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else {
                self.showAler(message: "Email does not exist")
                return
            }
            if let document = documents.first {
                let data = document.data()
                
                if let savedPassword = data["password"] as? String {
                    if savedPassword == user.password {
                        print("Logged in successfully")
                    } else {
                        self.showAler(message: "Wrong password")
                    }
                }
            }
        }
       
    }
    
    public func logOut() {
        do {
            try Auth.auth().signOut()
            print("Signed out successfully")
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    public func addingData(dateAndTime: String, task: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let newTask = TasksData(dateTime: dateAndTime, task: task)
        tasks.append(newTask)
        
        let userTasksCollection = db.collection("users").document(userId).collection("userTasks")
        
        userTasksCollection.addDocument(data: [
            "dateTime": dateAndTime,
            "task": task
        ]) { error in
            if let error = error {
                print("Error saving data: \(error.localizedDescription)")
            } else {
                print("Data saved successfully")
            }
        }
    }
   
    public func loadData(completion: @escaping ([TasksData]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            completion([])
            return
        }

        let userTasksCollection = db.collection("users").document(userId).collection("userTasks")
        userTasksCollection.order(by: "dateTime").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore. \(error)")
                completion([])
                return
            }

            var tasks: [TasksData] = []

            if let snapshotDocuments = querySnapshot?.documents {
                for doc in snapshotDocuments {
                    let data = doc.data()

                    if let dateTime = data["dateTime"] as? String, let task = data["task"] as? String {
                        let newTask = TasksData(dateTime: dateTime, task: task)
                        tasks.append(newTask)
                    }
                }
            }

            completion(tasks)
        }
    }

    public func deleteTaskFromFirestore(task: TasksData, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            completion(false)
            return
        }
        db.collection("users")
            .document(userId)
            .collection("userTasks")
            .whereField("dateTime", isEqualTo: task.dateTime)
            .whereField("task", isEqualTo: task.task)
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No matching documents found")
                    completion(false)
                    return
                }
                for document in documents {
                    document.reference.delete()
                }
                completion(true)
            }
    }
}
    
    
   
