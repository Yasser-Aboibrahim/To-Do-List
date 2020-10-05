//
//  SignInVC.swift
//  Todo List
//
//  Created by yasser on 9/20/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInVC: UIViewController {

    // MARK:- Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK:- Properties
    
    lazy var datacollection = Database.database().reference()
    var usersArr = [User]()
    
    // MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFielsBorder()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .purple
        UserDefaultManager.shared().isLoggedIn = false
        getUsers()
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

    private func isDataEntered()-> Bool{
        
        guard emailTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter Email",actionTitle: "Dismiss")
            return false
        }
        guard passwordTextField.text != "" else{
            showAlertWithCancel(alertTitle: "Incompleted Data Entry",message: "Please Enter Password",actionTitle: "Dismiss")
            return false
        }
        
        return true
    }
    
    private func isValidRegex() -> Bool{
        guard isValidEmail(email: emailTextField.text) else{
            showAlertWithCancel(alertTitle: "Alert",message: "Please Enter Valid Email",actionTitle: "Dismiss")
            return false
        }
        guard isValidPassword(testStr: passwordTextField.text) else{
            showAlertWithCancel(alertTitle: "Alert",message: "Password is Incorect",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
    private func gotoSignUpVC(){
        let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerKeys.signUpVC) as! SignUpVC
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func gotoTodoListVC(){
        let todoListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerKeys.todoiListVC) as! TodoListVC
        self.navigationController?.pushViewController(todoListVC, animated: true)
    }
    
    private func setTextFielsBorder(){
        
        emailTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        passwordTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
    }
    
    private func getUsers(){
        
        datacollection.child(FirebaseChildrenKeys.todoUserNote).observe(.value, with:
            { (snapshot) in
                
                
                self.usersArr = []
                if snapshot.exists() {
                    if let result = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        for child in result {
                            if let value = child.value as? [String: Any] {
                                let email = value[FirebaseChildrenKeys.userEmail] as? String ?? ""
                                let name = value[FirebaseChildrenKeys.userName] as? String ?? ""
                                let userData = User(name: name, email: email)
                                self.usersArr.append(userData)
                            }
                        }
                    }
                }
        })
    }
    
    
    private func signInUser(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {  authResult, error in
            
            guard error == nil else {
                print(error!.localizedDescription)
                self.showAlertWithCancel(alertTitle: "Error", message: "The account is not valid", actionTitle: "Cancel")
                return
            }
            
            for user in self.usersArr{
                if self.emailTextField.text! == user.email{
                    UserDefaultManager.shared().userName = user.name
                }
            }
            UserDefaultManager.shared().userEmail = self.emailTextField.text!
            self.gotoTodoListVC()
        }
    }
    
    // MARK:- Actions
    
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

    @IBAction func signInBtnTapped(_ sender: UIButton) {
        if isDataEntered(){
            if isValidRegex(){
                signInUser()
            }
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        gotoSignUpVC()
    }
    
}
