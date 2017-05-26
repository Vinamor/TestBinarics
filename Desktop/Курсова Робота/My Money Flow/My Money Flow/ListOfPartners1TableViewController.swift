//
//  ListOfPartners1TableViewController.swift
//  My Money Flow
//
//  Created by Marta Romaniv on 03.12.16.
//  Copyright © 2016 Ostap Romaniv. All rights reserved.
//

import UIKit
import os.log

class ListOfPartners1TableViewController: UITableViewController {
    
    // MARK: Properties:
    var partners1 = [ThePartnerInfo]()
    
    
    // MARK: - View Controller Life-cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
 
         loadSamplePartners()
       
//        if let savedPartners = loadPartners() {
//            partners1 += savedPartners
//        } else {
//            // Load sample data.
//            loadSamplePartners()
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

    // MARK: - Table view data source:
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return partners1.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ThePartnerTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ThePartnerTableViewCell else { return UITableViewCell() }
        
        let partner = partners1[indexPath.row]
        
        if let pI = partner.photo, let pN = partner.name, let pS = partner.surname, let pB = partner.currentBalance {
            
            cell.PartnerImage?.image = pI
            cell.PartnerNameSurname?.text = pN + " " + pS
            cell.PartnerBalance?.text = String(describing: pB)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            partners1.remove(at: indexPath.row)
            savePartners()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ShowDetail1" {
            
            let partnerDetailViewController = segue.destination as! PartnerInfoTableViewController

            partnerDetailViewController.numberOfRows = 5
            
            // Get the cell that generated this segue.
            if let selectedPartnerCell = sender as? ThePartnerTableViewCell {
                
                let indexPath = tableView.indexPath(for: selectedPartnerCell)!
                let selectedPartner = partners1[indexPath.row]
                partnerDetailViewController.partner = selectedPartner
            }
        } else if segue.identifier == "AddItem1" {
            print("Adding new partner.")
        }
    }
 
    // MARK: IBActions:
    @IBAction func unwindToPartnerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PartnerInfoTableViewController, let partner = sourceViewController.partner {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                partners1[selectedIndexPath.row] = partner
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new Partner.
                let newIndexPath = NSIndexPath(row: partners1.count, section: 0)
                partners1.append(partner)
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .top)
            }
            savePartners()
        }
    }
    
}

extension ListOfPartners1TableViewController {
    
    // MARK: NSCoding:
    fileprivate func savePartners() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(partners1, toFile: ThePartnerInfo.ArchieveURL1!.path)
        if isSuccessfulSave {
            os_log("Partners successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save partners...", log: OSLog.default, type: .error)
        }
    }
    
    fileprivate func loadPartners() -> [ThePartnerInfo]? {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: ThePartnerInfo.ArchieveURL1!.path) as? [ThePartnerInfo])
    }
    
    // MARK: Loading Test Data:
    func loadSamplePartners() {
        let photo1 = UIImage(named: "Image-1")!
        let photo2 = UIImage(named: "Image-2")!
        let photo3 = UIImage(named: "Image-3")!
        let partner1 = ThePartnerInfo(photo: photo1, name: "Marta", surname: "Romaniv", mobileNumber: "0931526915", email: "romanivmartha@gmail.com", currentBalance: -2300.00)
        let partner2 = ThePartnerInfo(photo: photo2, name: "National", surname: "Bank", mobileNumber: "0951321948", email: "nationalbank@gmail.com", currentBalance: -2500.00)
        let partner3 = ThePartnerInfo(photo: photo3, name: "Donald", surname: "Trump", mobileNumber: "5554446916", email: "trump@gmail.com", currentBalance: -3500.00)
        
        partners1 = [partner1, partner2, partner3]
    }
    
}
