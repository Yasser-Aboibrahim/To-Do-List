//
//  SignUpVC.swift
//  Todo List
//
//  Created by yasser on 9/19/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController{

    // MARK:- Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    // MARK:- Properties
    
    // MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFielsBorder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK:- Public Methods
    
    private func setTextFielsBorder(){
        userNameTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        emailTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        passwordTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
    }
    
    private func isDataEntered()-> Bool{
        guard userNameTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter Name",actionTitle: "Dismiss")
            return false
        }
        guard emailTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter email",actionTitle: "Dismiss")
            return false
        }
        guard passwordTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter Password",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
    private func isValidRegex() -> Bool{
        guard isValidEmail(email: emailTextField.text) else{showAlertWithCancel(alertTitle: "Wrong Email Form",message: "Please Enter Valid email(a@a.com)",actionTitle: "Dismiss")
            return false
        }
        guard isValidPassword(testStr: passwordTextField.text) else{
            showAlertWithCancel(alertTitle: "Wrong Password Form",message: "Password need to be : \n at least one uppercase \n at least one digit \n at leat one lowercase \n characters total",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
    private func gotoSignInVC(){
        let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerKeys.signInVC) as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
        
        
    }
    
    private func createUser()-> Bool{
        var flag = 1
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            guard self != nil else{
                return
            }
            
            guard error == nil else {
                print(error!.localizedDescription)
                self?.showAlertWithCancel(alertTitle: "Error", message: "Account creation failed", actionTitle: "Cancel")
                flag = 0
                return
            }
            
            guard let uid = authResult?.user.uid else {return}
            
            let values = [FirebaseChildrenKeys.userEmail: self!.emailTextField.text!,FirebaseChildrenKeys.userName: self!.userNameTextField.text!]
            Database.database().reference().child(FirebaseChildrenKeys.todoUserNote).child(uid).updateChildValues(values, withCompletionBlock: { (error,ref) in
                if let error = error {
                    print("Faild to update database", error.localizedDescription)
                    return
                }
                print("Successfully  signed user up")
            })
            
        }
        
        if flag == 0{
            return false
        }
        return true
    }
    
    // MARK:- Actions
    
    @IBAction func selectedUserNameTextField(_ sender: UITextField) {
        userNameTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        userNameLabel.text = "User Name"
        userNameTextField.placeholder = ""
    }
    
    @IBAction func unselectedUserNameTextField(_ sender: UITextField) {
        userNameTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        userNameLabel.text = ""
        userNameTextField.placeholder = "User Name"
    }
    
    @IBAction func selectedEmailTextField(_ sender: UITextField) {
        emailTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        emailLabel.text = "Email"
        emailTextField.placeholder = ""
    }
    
    @IBAction func unSelectedEmailTextField(_ sender: UITextField) {
        emailTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        emailLabel.text = ""
        emailTextField.placeholder = "Email"
    }
    
    @IBAction func selectedPasswordTextField(_ sender: UITextField) {
        passwordTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        passwordLabel.text = "Password"
        passwordTextField.placeholder = ""
    }
    
    @IBAction func unSelectedPasswordTextField(_ sender: UITextField) {
        passwordTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        passwordLabel.text = ""
        passwordTextField.placeholder = "Password"
    }

    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        if isDataEntered(){
            if isValidRegex(){
                if createUser(){
                    gotoSignInVC()
                }
            }
        }
    }
    
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        gotoSignInVC()
    }
}

