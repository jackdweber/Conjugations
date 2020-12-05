//
//  StudySet.swift
//  Conjugations
//
//  Created by Jack Weber on 5/2/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit
import CoreData

class StudySetManager: NSObject {
    var set: StudySet
    
    init(set: StudySet, random: Bool = false) {
        self.set = set
    }
    
    func getRandomList() -> [StudyItem] {
        return [set.items!]
    }
    
}
