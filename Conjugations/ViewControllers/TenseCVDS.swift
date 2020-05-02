//
//  TenseCVDS.swift
//  Conjugations
//
//  Created by Big Boi on 4/25/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit

class TenseCellView: UICollectionViewCell {
    var label: UILabel?
}

class TenseCVDS: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    let tenses: [String]!
    let onSelection: () -> Void
    
    init(tenses: [String], onSelection: @escaping () -> Void) {
        self.tenses = tenses
        self.onSelection = onSelection
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tenses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TenseCell", for: indexPath) as! TenseCellView
        let label = cell.label ?? UILabel(frame: .zero)
        cell.label = label
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        label.text = self.tenses[indexPath.row]
        label.adjustsFontSizeToFitWidth = false
        label.font = UIFont.systemFont(ofSize: 25.0)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0),
            cell.contentView.widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 1),
            cell.contentView.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1),
            cell.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 1)
        ])
        if indexPath.row == collectionView.indexPathsForSelectedItems?[0][1] ?? -1 {
            label.textColor = collectionView.tintColor
        } else {
            label.textColor = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TenseCellView else {
            return
        }
        cell.label?.textColor = collectionView.tintColor
        self.onSelection()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TenseCellView else {
            return
        }
        cell.label?.textColor = UIColor.black
    }

}
