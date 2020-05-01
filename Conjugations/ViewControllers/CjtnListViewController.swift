//
//  CjtnListViewController.swift
//  Conjugations
//
//  Created by Big Boi on 4/21/20.
//  Copyright © 2020 Brick. All rights reserved.
//

import UIKit
import CoreData

class CjtnListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var fetchedResultsController: NSFetchedResultsController<Conjugation>?
    var predicate: NSPredicate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Verbos"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.search(text: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
     
    func initializeFetchedResultsController() {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = ad.persistentContainer.viewContext
        
        let request = NSFetchRequest<Conjugation>(entityName: "Conjugation")
        request.predicate = self.predicate
        let departmentSort = NSSortDescriptor(key: "infinitive", ascending: true)
        request.sortDescriptors = [departmentSort]
        
        if let controller = fetchedResultsController {
            do {
                controller.fetchRequest.predicate = self.predicate
                try controller.performFetch()
            } catch {
                fatalError("Failed to initialize FetchedResultsController: \(error)")
            }
            self.tableView.reloadData()
            return
        }
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CjtnDetailSegue", let object = sender as? Conjugation {
            let vc = segue.destination as! CjtnDetailViewController
            vc.cjtn = object
        }
    }
    
    func search(text: String) {
        if text != "" {
            self.predicate = NSPredicate(format: "mood_en MATCHES[c] 'indicative' AND tense_en MATCHES[c] 'present' AND (infinitive CONTAINS[c] %@ OR infinitive_en CONTAINS[c] %@)", text, text)
        } else {
            self.predicate = NSPredicate(format: "mood_en MATCHES[c] 'indicative' AND tense_en MATCHES[c] 'present'", [])
        }
        self.initializeFetchedResultsController()
    }
}

extension CjtnListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let c = fetchedResultsController else {
            return 0
        }
        return c.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CjtnCell", for: indexPath)
        
        // Set up the cell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
    
        cell.textLabel?.text = object.infinitive
        cell.detailTextLabel?.text = object.infinitive_en
        
        //Populate the cell from the object
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        performSegue(withIdentifier: "CjtnDetailSegue", sender: object)
    }
}

extension CjtnListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search(text: searchText)
    }
}

extension CjtnListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
