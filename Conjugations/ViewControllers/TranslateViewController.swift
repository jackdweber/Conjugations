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
    @IBOutlet weak var responseView: UITextView!
    @IBOutlet weak var sourceView: UITextView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    let searchViewTopStart = CGFloat(128)
    
    let placeholder_en = "Hello World!"
    let placeholder_es = "¡Hola Mundo!"
    
    let aEspanol = "to=en&from=es"
    let aIngles = "to=es&from=en"
    
    var constraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Delegate
//        searchView.delegate = self
//
//        // Initial constaints
//        searchView.translatesAutoresizingMaskIntoConstraints = false
//
//        constraints.append(self.searchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height / 2 - self.searchView.frame.height / 2))
//
//        NSLayoutConstraint.activate(constraints)
        sourceView.text = placeholder_es
        sourceView.delegate = self
    }
    
    func translate(text: String) {
        let linguas = (segmentView.selectedSegmentIndex > 0) ? aIngles : aEspanol
        Translate.translate(phrase: text, linguas: linguas) { (status, res) in
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
    
    @IBAction func didswitch(_ sender: Any) {
        if sourceView.text != placeholder_en && sourceView.text != placeholder_es {
            sourceView.text = responseView.text
            translate(text: sourceView.text)
        } else {
            textViewDidEndEditing(sourceView)
        }
    }
}

extension TranslateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder_en || textView.text == placeholder_es {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = (segmentView.selectedSegmentIndex > 0) ? placeholder_en : placeholder_es
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.translate(text: textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            self.view.endEditing(true)
            return false
        }
        return true
    }
}

//extension TranslateViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.constraints[0].constant = searchViewTopStart + self.view.safeAreaInsets.top
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let c = textField.text?.count, c <= 0 else {
//            return
//        }
//        self.constraints[0].constant = self.view.frame.height / 2 - self.searchView.frame.height / 2
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//    }
//}
