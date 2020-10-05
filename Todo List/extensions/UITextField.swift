//
//  UITextField.swift
//  Todo List
//
//  Created by yasser on 10/4/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import UIKit
extension UITextField{
 
    
    
    func setBottomBorder(borderColor: CGColor = UIColor.white.cgColor,
                         backgroundColor: CGColor = UIColor.clear.cgColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = backgroundColor
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = borderColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
