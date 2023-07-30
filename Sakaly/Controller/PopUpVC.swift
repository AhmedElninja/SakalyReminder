//
//  PopUpVC.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 24/06/2023.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseFirestore

// Mark: - PopUpVCDelegate
protocol PopUpVCDelegate: class {
    func didSaveTask(_ task: TasksData)
}

class PopUpVC: UIViewController {
    
    //Mark: - OUtlets.
    @IBOutlet weak var dateAndTimeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var taskTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var dateAndTimePicker: UIButton!
    
    //Mark: - Properties.
    var tasks: [TasksData] = []
    let db = Firestore.firestore()
    weak var delegate: PopUpVCDelegate?
      let datePicker = UIDatePicker()
    
    
    //Mark: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        confirgurDateAndTime()
        self.modalPresentationStyle = .fullScreen
        let tapGeuster = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGeuster.delegate = self
        self.view.addGestureRecognizer(tapGeuster)
    }
    
    //Mark: - Actions.
    @IBAction func dateAndTimeBtnTapped(_ sender: UIButton) {
        dateAndTimeTextField.inputView = datePicker
        dateAndTimeTextField.becomeFirstResponder()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if isDateEntered() {
            let newTask = TasksData(dateTime: dateAndTimeTextField.text!, task: taskTextField.text!)
                    delegate?.didSaveTask(newTask)
            FireBaseManger.shared.addingData(dateAndTime: dateAndTimeTextField.text!, task: taskTextField.text!)
            dismissPopUpVC()
        }
    }
}

//Mark: - extension PopUpVC.
extension PopUpVC {
    func isDateEntered() -> Bool {
        guard let dateAndTime = dateAndTimeTextField.text, !dateAndTime.isEmpty else {
            showAler(message: "You must choose Date and time")
            return false
        }
        guard let task = taskTextField.text, !task.isEmpty else {
            showAler(message: "You must enter data")
            return false
        }
        self.view.removeFromSuperview()
        return true
    }
    @objc func dateChange(datePicker: UIDatePicker) {
        dateAndTimeTextField.text = formatDateandTime(dateAndTime: datePicker.date)
    }
    
    func formatDateandTime(dateAndTime: Date) -> String {
         let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy - HH:mm"
        return formatter.string(from: dateAndTime)
    }
    func confirgurDateAndTime() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        dateAndTimeTextField.text = formatDateandTime(dateAndTime: Date())
    }
    func dismissPopUpVC() {
        self.navigationController?.isNavigationBarHidden = false
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
extension PopUpVC: UIGestureRecognizerDelegate {
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        dismissPopUpVC()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}

    
  
    

