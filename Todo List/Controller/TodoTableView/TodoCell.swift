//
//  TodoCell.swift
//  Todo List
//
//  Created by yasser on 9/20/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TodoCell: UITableViewCell {

    // MARK:- Outlets
    
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK:- Properties
    
    var noteRef: note?
    
    // MARK:- Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- Public Methods
    
    func configure(note: note){
        dateAndTimeLabel.text = note.date
        contentLabel.text = note.content
        noteRef = note
        
    }
    
    // MARK:- Actions
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        
        let deleteAlert = UIAlertController(title: "Sorry", message: "Are You Sure You Want To Delete This TODO?", preferredStyle: .alert)
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            guard let user = Auth.auth().currentUser else {return}
            let uid = user.uid
            Database.database().reference().child(FirebaseChildrenKeys.todoUserNote).child(uid).child(FirebaseChildrenKeys.notes).child(self.noteRef!.id!).removeValue()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(deleteAlert, animated: true, completion: nil)
        
        
    }
}
