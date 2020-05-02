//
//  CjtnDetailViewController.swift
//  Conjugations
//
//  Created by Big Boi on 4/21/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit
import CoreData

class CjtnDetailViewController: UIViewController {
    @IBOutlet weak var present1: UILabel!
    @IBOutlet weak var meaning: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tenseCollection: UICollectionView!
    @IBOutlet weak var moodCollection: UICollectionView!
    @IBOutlet weak var formCollection: UICollectionView!
    
    @IBOutlet weak var f1s: UILabel!
    @IBOutlet weak var f2s: UILabel!
    @IBOutlet weak var f3s: UILabel!
    @IBOutlet weak var f3p: UILabel!
    @IBOutlet weak var f1p: UILabel!
    @IBOutlet weak var f2p: UILabel!
    
    
    var cjtn: Conjugation?
    var cjtns: [Conjugation]?
    
    var tenseDS = TenseCVDS(tenses: [], onSelection: {})
    var moodDS = TenseCVDS(tenses: [], onSelection: {})
    var formDS = TenseCVDS(tenses: [], onSelection: {})
    
    override func viewDidLoad() {
        super.viewDidLoad()
        present1.text = cjtn?.infinitive
        meaning.text = cjtn?.infinitive_en
        prepareCollections()
        showCjtn()
    }
    
    func prepareCollections() {
        let all = getAllTenses()
        guard all.count > 0 else {
            return
        }
        cjtns = all
        tenseDS = TenseCVDS(tenses: self.getTenses(cjtns: all), onSelection: { self.showCjtn() })
        moodDS = TenseCVDS(tenses: self.getMoods(cjtns: all), onSelection: { self.showCjtn() })
        formDS = TenseCVDS(tenses: self.getForms(cjtns: all), onSelection: { self.showCjtn() })
        
        let delegates = [tenseDS, moodDS, formDS]
        let collections = [tenseCollection, moodCollection, formCollection]
        
        for i in 0..<3 {
            let c = collections[i]
            c?.delegate = delegates[i]
            c?.dataSource = delegates[i]
            c?.tintColor = view.tintColor
            c?.allowsMultipleSelection = false
            c?.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    func getAllTenses() -> [Conjugation] {
        guard let ad = UIApplication.shared.delegate as? AppDelegate, let inf = self.cjtn?.infinitive else {
            return []
        }
        let context = ad.persistentContainer.viewContext
        let request = NSFetchRequest<Conjugation>(entityName: "Conjugation")
        request.predicate = NSPredicate(format: "infinitive MATCHES[c] %@", inf)
        if let res = try? context.fetch(request) {
            return res
        } else {
            return []
        }
    }
    
    func getTenses(cjtns: [Conjugation]) -> [String] {
        return ["Present", "Future", "Imperfect", "Preterite", "Conditional"]
    }
    
    func getMoods(cjtns: [Conjugation]) -> [String] {
        return ["Indicative", "Subjunctive", "Imperative Affirmative", "Imperative Negative"]
    }
    
    func getForms(cjtns: [Conjugation]) -> [String] {
        return ["Simple", "Perfect"]
    }
    
    func getCjtnForTense(tense: String, mood: String, form: String) -> Conjugation? {
        guard let all = cjtns else {
            return nil
        }
        
        let ret = all.filter({
            guard let t = $0.tense_en, let m = $0.mood_en else {
                return false
            }
            var ret = t.contains(tense)
            if form == "Perfect" {
                ret = ret && ( t.contains("Perfect") || t.contains("Archaic") )
            } else {
                ret = ret && t == tense
            }
            return ret && m.contains(mood)
        })
        
        if ret.count > 0 {
            return ret[0]
        } else {
            return nil
        }
    }
    
    public func showCjtn() {
        let t = getTenses(cjtns: [])[tenseCollection.indexPathsForSelectedItems?[0][1] ?? 0]
        let m = getMoods(cjtns: [])[moodCollection.indexPathsForSelectedItems?[0][1] ?? 0]
        let f = getForms(cjtns: [])[formCollection.indexPathsForSelectedItems?[0][1] ?? 0]
        
        let c = getCjtnForTense(tense: t, mood: m, form: f)
        
        f1s.text = c?.form_1s
        f2s.text = c?.form_2s
        f3s.text = c?.form_3s
        f3p.text = c?.form_3p
        f1p.text = c?.form_1p
        f2p.text = c?.form_2p
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
