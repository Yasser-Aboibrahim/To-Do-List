//
//  Note.swift
//  Todo List
//
//  Created by yasser on 9/27/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation

struct note: Codable {
    var id: String? = nil
    var date: String
    var content: String
}
