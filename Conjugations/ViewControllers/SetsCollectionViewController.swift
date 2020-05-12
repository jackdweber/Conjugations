//
//  SetsCollectionViewController.swift
//  Conjugations
//
//  Created by Big Boi on 5/9/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit

private let reuseIdentifier = "StudySetCell"

class SetsCollectionViewController: UICollectionViewController {
    
    private var sets: [StudySet] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData(){
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = ad.persistentContainer.viewContext
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let res = CoreDataUtils.fetchSets(predicate: nil, context: context){
                self.sets = res.sorted(by: { (s1, s2) -> Bool in
                    return s1.name!.lowercased() < s2.name!.lowercased()
                })
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func addSet(name: String) {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = ad.persistentContainer.viewContext
        
        let set = StudySet(context: context)
        set.name = name
        
        try? context.save()
        
        self.loadData()
    }
    
    @IBAction func addStudySet(_ sender: Any) {
        let alert = UIAlertController(title: "New Study Set", message: "Please add a title", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        
        let actionNo = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionYes = UIAlertAction(title: "Create", style: .default) { (a) in
            if let field = alert.textFields?[0], let text = field.text {
                if text == "" || text.trimmingCharacters(in: .whitespaces) == ""{
                    return
                }
                self.addSet(name: text)
            }
        }
        
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? StudySetCell else{
            return UICollectionViewCell()
        }
        
        cell.contentView.backgroundColor = view.tintColor
        cell.contentView.layer.cornerRadius = 5
        
        // Initialize label
        let label: UILabel = cell.label ?? UILabel()
        cell.label = label
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
        ])
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = sets[indexPath.row].name
        label.textColor = UIColor.label
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
