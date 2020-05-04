//
//  TranslateViewController.swift
//  Conjugations
//
//  Created by Jack Weber on 5/2/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var searchView: UITextField!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var responseView: UITextView!
    
    let searchViewTopStart = CGFloat(128)
    
    var constraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate
        searchView.delegate = self
        
        // Initial constaints
        searchView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(self.searchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height / 2 - self.searchView.frame.height / 2))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @IBAction func textChange(_ sender: Any) {
        guard let field = sender as? UITextField, let text = field.text else {
            return
        }
        Translate.translate(phrase: text) { (status, res) in
            DispatchQueue.main.async {
                if status {
                    self.responseView.textColor = UIColor.label
                    self.responseView.text = res
                } else {
                    self.responseView.textColor = UIColor.systemRed
                    self.responseView.text = "Please check your internet connection."
                }
            }
        }
    }
}

extension TranslateViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.constraints[0].constant = searchViewTopStart + self.view.safeAreaInsets.top
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let c = textField.text?.count, c <= 0 else {
            return
        }
        self.constraints[0].constant = self.view.frame.height / 2 - self.searchView.frame.height / 2
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
