//
//  TodoUserNote.swift
//  Todo List
//
//  Created by yasser on 9/27/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation

struct todoUserNote: Codable {
    var userName: String
    var useEmail: String
    var notes: [note]
}
