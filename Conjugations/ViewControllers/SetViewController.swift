//
//  SetViewController.swift
//  Conjugations
//
//  Created by Jack Weber on 7/3/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    var set: StudySet?
    var items: [StudyItem] = []
    var currentItem = 0

    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = set?.name
        updateCard()
    }
    
    @IBAction func cardButtonAction(_ sender: Any) {
        guard items.count > currentItem && currentItem >= 0 else {
            return
        }
        if cardButton.titleLabel?.text == items[currentItem].en {
            cardButton.titleLabel?.text = items[currentItem].es
        } else {
            cardButton.titleLabel?.text = items[currentItem].en
        }
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        currentItem += 1
        updateCard()
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        currentItem = min(currentItem - 1, 0)
    }
    
    func updateCard(){
        if currentItem >= items.count {
            finish()
        } else{
            cardButton.setTitle(items[currentItem].en, for: .normal)
        }
    }
    
    func finish() {
        cardButton.setTitle("Restart?", for: .normal)
        titleLabel.text = "Finished!"
    }
}
