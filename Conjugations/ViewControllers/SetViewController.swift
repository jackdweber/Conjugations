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

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = set?.name
    }
}
