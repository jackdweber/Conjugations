//
//  StudyViewController.swift
//  Conjugations
//
//  Created by Big Boi on 5/11/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit
import CoreData

class StudySetCell: UICollectionViewCell {
    var label: UIButton?
}

class StudyViewController: UIViewController {

    @IBOutlet weak var segmentsView: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var sets: [StudySet] = []
    private let fakeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private var addSet: StudySet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSet = StudySet(context: fakeContext)
        addSet!.name = "Add Set"
        
        loadData()
    }
    
    func loadData(){
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = ad.persistentContainer.viewContext
        self.sets = []
        if self.segmentsView.selectedSegmentIndex > 0 {
            if let res = CoreDataUtils.fetchCustomSets(context: context){
                self.sets = res.sorted(by: { (s1, s2) -> Bool in
                    return s1.name!.lowercased() < s2.name!.lowercased()
                })
            }
            DispatchQueue.main.async {
                self.sets.insert(self.addSet!, at: 0)
                self.collectionView.reloadData()
            }
        } else {
            if let res = CoreDataUtils.fetchFeaturedSets(context: context){
                self.sets = res.sorted(by: { (s1, s2) -> Bool in
                    return s1.name!.lowercased() < s2.name!.lowercased()
                })
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
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
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.alpha = 0.0
        }, completion: { (_) in
            DispatchQueue.main.async {
                self.loadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
                if let l = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    if sender.selectedSegmentIndex > 0 {
                        l.scrollDirection = .vertical
                    } else {
                        l.scrollDirection = .horizontal
                    }
                    self.collectionView.setCollectionViewLayout(l, animated: false)
                    UIView.animate(withDuration: 0.5, animations: {
                        self.collectionView.alpha = 1.0
                    })
                }
            }
        })
    }
    
    @objc func addStudySet() {
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
    
    @objc func viewStudySet(){
        self.performSegue(withIdentifier: "ShowSetSegue", sender: self)
    }
}

extension StudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudySetCell", for: indexPath) as? StudySetCell else{
            return UICollectionViewCell()
        }
        
        cell.contentView.backgroundColor = view.tintColor
        cell.contentView.layer.cornerRadius = 5
        
        // Initialize label
        let label: UIButton = cell.label ?? UIButton()
        cell.label = label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.removeTarget(nil, action: nil, for: .allEvents)
        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: 0)
        ])
        label.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        label.setTitle(sets[indexPath.row].name, for: .normal)
        label.tintColor = UIColor.white
        label.titleLabel?.textAlignment = NSTextAlignment.center
        
        // If it is an "Add set button"
        if self.segmentsView.selectedSegmentIndex > 0 && indexPath.row == 0 {
            cell.contentView.backgroundColor = UIColor.systemBlue
            label.setTitle("Add Set", for: .normal)
            label.addTarget(self, action: #selector(addStudySet), for: .touchUpInside)
        } else {
            label.addTarget(self, action: #selector(viewStudySet), for: .touchUpInside)
        }
    
        return cell
    }
}

extension StudyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = (collectionView.frame.width / 5) * 0.5
        let height = (collectionView.frame.height / 5) * 0.5
        return UIEdgeInsets(top: height, left: width, bottom: height, right: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((view.frame.width - 40) / 5) * 4
        var height = (collectionView.frame.height / 5) * 4
        if segmentsView.selectedSegmentIndex > 0 {
            height /= 4
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.width / 5) * 0.5
    }
}
