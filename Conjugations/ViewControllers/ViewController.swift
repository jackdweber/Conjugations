//
//  ViewController.swift
//  Conjugations
//
//  Created by Big Boi on 4/12/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var assestsActivityIndicator: UIActivityIndicatorView!
    
    var loaded = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        assestsActivityIndicator.startAnimating()
        
        // Setup for CoreData
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = ad.persistentContainer.viewContext
        
        // Debugging, print random value to log from core data
        let request = NSFetchRequest<Conjugation>(entityName: "Conjugation")
        let reg = "^da.*"
        request.predicate = NSPredicate(format: "infinitive MATCHES[c] %@", reg)
        if let res = try? context.fetch(request), res.count > 0, let word = res[0].infinitive {
            print(word)
        } else {
            // If there is a conjugations plist, upload to core data.
            print("Polulating Conjugations")
            if let path = Bundle.main.path(forResource: "conjugations", ofType: "plist"),
                let cjtns = NSArray(contentsOfFile: path){
                
                for i in 1..<cjtns.count{
                    if let cjtnInfo: NSArray = cjtns[i] as? NSArray{
                        let cjtnMo = Conjugation(context: context)
                        cjtnMo.infinitive = cjtnInfo[0] as? String
                        cjtnMo.infinitive_en = cjtnInfo[1] as? String
                        cjtnMo.mood = cjtnInfo[2] as? String
                        cjtnMo.mood_en = cjtnInfo[3] as? String
                        cjtnMo.tense = cjtnInfo[4] as? String
                        cjtnMo.tense_en = cjtnInfo[5] as? String
                        cjtnMo.verb_en = cjtnInfo[6] as? String
                        cjtnMo.form_1s = cjtnInfo[7] as? String
                        cjtnMo.form_2s = cjtnInfo[8] as? String
                        cjtnMo.form_3s = cjtnInfo[9] as? String
                        cjtnMo.form_1p = cjtnInfo[10] as? String
                        cjtnMo.form_2p = cjtnInfo[11] as? String
                        cjtnMo.form_3p = cjtnInfo[12] as? String
                        cjtnMo.gerund = cjtnInfo[13] as? String
                        cjtnMo.gerund_en = cjtnInfo[14] as? String
                        cjtnMo.past_participle = cjtnInfo[15] as? String
                        cjtnMo.past_participle_en = cjtnInfo[16] as? String
                    }
                }
                
                try! context.save()
            }
        }
        
        loaded = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // So it doesn't flash
        while !loaded {
            Thread.sleep(forTimeInterval: 700)
        }
        self.performSegue(withIdentifier: "StartSegue", sender: nil)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}

