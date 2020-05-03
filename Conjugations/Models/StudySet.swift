//
//  StudySet.swift
//  Conjugations
//
//  Created by Jack Weber on 5/2/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit
import CoreData

class StudySet: NSObject {
    var verbs: [String] = []
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext, name: String? = nil, random: Bool = false) {
        self.context = context
    }
    
    
}
