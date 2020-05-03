//
//  Utils.swift
//  Conjugations
//
//  Created by Jack Weber on 5/2/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit
import CoreData

class Utils: NSObject {
    
    static func fetch(predicate: NSPredicate, context: NSManagedObjectContext) -> Conjugation? {
        let request = NSFetchRequest<Conjugation>(entityName: "Conjugation")
        request.predicate = predicate
        if let res = try? context.fetch(request), res.count > 0 {
            return res[0]
        } else {
            return nil
        }
    }
    
    static func fetchCjtnByName(name: String, context: NSManagedObjectContext) -> Conjugation? {
        let predicate = NSPredicate(format: "infinitive MATCHES[c] %@", name)
        if let res = Utils.fetch(predicate: predicate, context: context) {
            return res
        } else {
            print("Could not find conjugation: \(name)")
            return nil
        }
    }
    
    static func fetchAllInfinitive(context: NSManagedObjectContext) -> Conjugation? {
        let predicate = NSPredicate(format: "mood_en MATCHES[c] 'indicative' AND tense_en MATCHES[c] 'present'", [])
        if let res = Utils.fetch(predicate: predicate, context: context) {
            return res
        } else {
            print("Could not find conjugations")
            return nil
        }
    }
}