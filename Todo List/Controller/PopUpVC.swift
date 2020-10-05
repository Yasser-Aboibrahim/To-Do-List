//
//  PopUpVC.swift
//  Todo List
//
//  Created by yasser on 9/24/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class PopUpVC: UIViewController {

    // MARK:- Outlets
    
    @IBOutlet weak var dateAndTimeTextfield: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var noteContentLabel: UILabel!

    // MARK:- Properties
    let datePicker = UIDatePicker()
    
    // MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerBackground()
        setBlurBackground()
        setTextFielsBorder()
        createDatePicker()
    }
    
    // MARK:- Public Methods
    
    private func setBlurBackground(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    private func viewControllerBackground(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKeys.popUpVC) as! PopUpVC
        // vc.delegate = self
        vc.providesPresentationContextTransitionStyle = true;
        vc.definesPresentationContext = true;
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    private func setTextFielsBorder(){
        dateAndTimeTextfield.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        contentTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
    }
    
    private func createDatePicker(){
        // toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDateAndTimePicking))
        toolBar.setItems([doneBtn], animated: true)
        //assign toolbar
        datePicker.datePickerMode = .dateAndTime
        dateAndTimeTextfield.inputAccessoryView = toolBar
        //Current Date
        datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        //assign date picker to the text field
        dateAndTimeTextfield.inputView = datePicker
    }
    
    private func isDataEntered()-> Bool{
        guard dateAndTimeTextfield.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "No Time and Date",actionTitle: "Dismiss")
            return false
        }
        guard contentTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "No Content",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
    @objc private func doneDateAndTimePicking(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        dateAndTimeTextfield.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    private func donePressed(){
        guard let user = Auth.auth().currentUser else {return}
        let uid = user.uid
        let child = Database.database().reference().child(FirebaseChildrenKeys.todoUserNote).child(uid).child(FirebaseChildrenKeys.notes).childByAutoId()
        let noteId = child.key
        let newNote = note(id: noteId, date: dateAndTimeTextfield.text!, content: contentTextField.text!)
        let data = try! FirebaseEncoder().encode(newNote)
        child.setValue(data, withCompletionBlock: { (error,ref) in
            if let error = error {
                print("Faild to set value", error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            }
            print("Successfully value set")
            self.dismiss(animated: true, completion: nil)
        })
    }

    // MARK:- Actions
    
    @IBAction func selectedDateAndTimeTextField(_ sender: UITextField) {
        dateAndTimeTextfield.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        dateAndTimeLabel.text = "Date/Time"
        dateAndTimeTextfield.placeholder = ""
    }
    @IBAction func unSelectedDateAndTimeTextField(_ sender: UITextField) {
        dateAndTimeTextfield.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        dateAndTimeLabel.text = ""
        dateAndTimeTextfield.placeholder = "Date/Time"
    }
    
    @IBAction func selectedNoteContentTextField(_ sender: UITextField) {
        contentTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        noteContentLabel.text = "Note"
        dateAndTimeTextfield.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        dateAndTimeLabel.text = ""
        contentTextField.placeholder = ""
        dateAndTimeTextfield.placeholder = "Date/Time"
    }
    
    @IBAction func unSelectedNoteContentTextField(_ sender: UITextField) {
        contentTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        noteContentLabel.text = ""
        contentTextField.placeholder = "Note"
    }
  
    @IBAction func saveNoteBtnTapped(_ sender: UIButton) {
        if isDataEntered(){
            donePressed()
        }
    }
}
