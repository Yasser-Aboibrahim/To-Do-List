//
//  TodoListVC.swift
//  Todo List
//
//  Created by yasser on 9/20/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON
import CodableFirebase

class TodoListVC: UIViewController {

    // MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Properties
    
    var noteArr = [note]()
    lazy var datacollection = Database.database().reference()
    
    // MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setTableView()
        UserDefaultManager.shared().isLoggedIn = true
        setNavbar()
        
    }
    
    // MARK:- Public Methods
    
    @objc private func tapLeftBtn(){
        gotoSignInVC()
    }
    
    @objc private func tapRightBtn(){
        gotoPopUpVC()
    }
    
    private func setNavbar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backArrow") , style: .plain, target: self, action:  #selector(tapLeftBtn))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(tapRightBtn))
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 25.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white],for: .normal)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = UserDefaultManager.shared().userName
    }
    
    private func getData(){
        
        guard let user = Auth.auth().currentUser else {return}
        let uid = user.uid

        datacollection.child(FirebaseChildrenKeys.todoUserNote).child(uid).child(FirebaseChildrenKeys.notes).observe(.value, with:
            { (snapshot) in
                
                self.noteArr = []
                if snapshot.exists() {
                    if let result = snapshot.children.allObjects as? [DataSnapshot] {
                        for child in result {
                            if let value = child.value as? [String: Any] {
                                let dateAndTime = value[FirebaseChildrenKeys.date] as? String ?? ""
                                let content = value[FirebaseChildrenKeys.content] as? String ?? ""
                                let id = child.key
                                let noteData = note(id: id, date: dateAndTime, content: content)
                                self.noteArr.append(noteData)
                                print(dateAndTime, content)
                        }
                    }
                }
            }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        })
    }

    private func setTableView(){
        tableView.register(UINib(nibName: Cells.todoCell, bundle: nil), forCellReuseIdentifier: Cells.todoCell)
        SetDelegate()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func SetDelegate(){
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    private func gotoSignInVC(){
        let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerKeys.signInVC) as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func gotoPopUpVC(){
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerKeys.popUpVC) as! PopUpVC
        self.present(popUpVC, animated: true, completion: nil)
    }

}

// MARK:- Tableview Extension

extension TodoListVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(noteArr.count)
        return noteArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.todoCell, for: indexPath) as? TodoCell else{
            return UITableViewCell()
        }
        cell.configure(note: self.noteArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
