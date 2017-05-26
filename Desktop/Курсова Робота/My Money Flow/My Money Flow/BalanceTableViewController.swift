//
//  BalanceTableViewController.swift
//  My Money Flow
//
//  Created by Marta Romaniv on 06.12.16.
//  Copyright © 2016 Ostap Romaniv. All rights reserved.
//

import UIKit
import os.log

class BalanceTableViewController: UITableViewController {
    
    // MARK: Properties
    var notes = [TheReportNote]()
    var backController: PartnerInfoTableViewController?

    
    // MARK: IBActions
    @IBAction func cancel(_ sender: UIBarButtonItem) {

//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyBoard.instantiateViewController(withIdentifier: "PartnerInfoTVCID") as! PartnerInfoTableViewController
//        controller.backController = self
//        controller.PartnerBalance.text = String(describing: TheReportNote.balance(array: &notes) ?? 0.0)
//        present(controller, animated: true, completion: nil)

        self.dismiss(animated: true, completion: nil)
    }

    
    func loadSampleNotes() {
        let date = Calendar.current.date(from: DateComponents(year: 2016, month: 10, day: 22))
        let note1 = TheReportNote(date: date, sum: 1000)
        let note2 = TheReportNote(date: date, sum: 500)
        let note3 = TheReportNote(date: date, sum: 500)
        
        notes = [note1, note2, note3]
    }
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleNotes()
        
        //design()
        
//        if let savedNotes = loadNotes() {
//            
//            notes += savedNotes
//            
//        } else {
//            
//            loadSampleNotes()
//        }
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BalanceTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BalanceTableViewCell
        
        let note = notes[indexPath.row]
        
        if let nD = note.date, let nS = note.sum {
            
            cell.theDateLabel.text = String(describing: nD)
            cell.theSumLabel.text = String(describing: nS)
            
            navigationItem.title = String(describing: (TheReportNote.balance(array: &notes))!)
        }
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            notes.remove(at: indexPath.row)
            saveNotes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let noteDetailViewController = segue.destination as! BalanceViewController
            
            // Get the cell that generated this segue.
            if let selectedBalanceCell = sender as? BalanceTableViewCell {
                let indexPath = tableView.indexPath(for: selectedBalanceCell)!
                let selectedNote = notes[indexPath.row]
                noteDetailViewController.note = selectedNote
            }
        } else if segue.identifier == "AddItem" {
            print("Adding new monetary event.")
        }
    }
    
    @IBAction func unwindToNotesList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? BalanceViewController, let note = sourceViewController.note {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                notes[selectedIndexPath.row] = note
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new Monetary Event.
                let newIndexPath = NSIndexPath(row: notes.count, section: 0)
                notes.append(note)
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            }
            saveNotes()
        }
    }
    
    // MARK: NSCoding
    func saveNotes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(notes, toFile: TheReportNote.ArchieveURL!.path)
        if isSuccessfulSave {
            os_log("Notes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save notes...", log: OSLog.default, type: .error)
        }
    }
    
    func loadNotes() -> [TheReportNote]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: TheReportNote.ArchieveURL!.path) as? [TheReportNote]
    }
    
}

extension BalanceTableViewController {
    fileprivate func design() {
        
        let image = UIImage(named: "BackgroundPic")
        let imageView = UIImageView(image: image)
        imageView.layer.frame.size.height = self.tableView.layer.frame.size.height
        imageView.layer.frame.size.width = self.tableView.layer.frame.size.width
        
        //self.tableView.addSubview(imageView)
        self.tableView.backgroundView?.addSubview(imageView)
    
        let view = UIView()
        view.layer.frame.size.height = self.tableView.layer.frame.size.height
        view.layer.frame.size.width = self.tableView.layer.frame.size.width
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //self.tableView.addSubview(blurEffectView)
        
        self.tableView.backgroundView?.addSubview(blurEffectView)
     

    }
}
