//
//  ListOfPartners2TableViewController.swift
//  My Money Flow
//
//  Created by Marta Romaniv on 05.12.16.
//  Copyright © 2016 Ostap Romaniv. All rights reserved.
//

import UIKit
import os.log

class ListOfPartners2TableViewController: UITableViewController {

    // MARK: Properties
    var partners = [ThePartnerInfo]()
    
    
    // MARK: - View Controller Life-cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSamplePartners()
      
        
//        if let savedPartners = loadPartners() {
//            partners += savedPartners
//        } else {
//            // Load the sample data.
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return partners.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ThePartnerTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ThePartnerTableViewCell else { return UITableViewCell() }
        
    
        // Fetches the appropriate meal for the data source layout.
        let partner = partners[indexPath.row]
        
        if let pI = partner.photo, let pN = partner.name, let pS = partner.surname, let pB = partner.currentBalance {
            
            cell.PartnerImage2?.image = pI
            cell.PartnerNameSurname2?.text = pN + " " + pS
            cell.PartnerBalance2?.text = String(describing: pB)
            
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
            partners.remove(at: indexPath.row)
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
        
        if segue.identifier == "ShowDetail2" {
           
            let partnerDetailViewController = segue.destination as! PartnerInfoTableViewController
            
            partnerDetailViewController.numberOfRows = 4
            // Get the cell that generated this segue.
            if let selectedPartnerCell = sender as? ThePartnerTableViewCell {
                let indexPath = tableView.indexPath(for: selectedPartnerCell)!
                let selectedPartner = partners[indexPath.row]
                partnerDetailViewController.partner = selectedPartner
            }
        }
        else if segue.identifier == "AddItem2" {
            print("Adding new partner.")
        }
     }
 
    // MARK: - IBActions:
    @IBAction func unwindToPartnerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PartnerInfoTableViewController, let partner = sourceViewController.partner {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                partners[selectedIndexPath.row] = partner
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new Partner.
                let newIndexPath = NSIndexPath(row: partners.count, section: 0)
                partners.append(partner)
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .top)
            }
            savePartners()
        }
    }
    
}

extension ListOfPartners2TableViewController {
    // MARK: NSCoding
    fileprivate func savePartners() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(partners, toFile: ThePartnerInfo.ArchieveURL2!.path)
        if isSuccessfulSave {
            os_log("Partners successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save partners...", log: OSLog.default, type: .error)
        }
    }

    fileprivate func loadPartners() -> [ThePartnerInfo]? {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: ThePartnerInfo.ArchieveURL2!.path) as? [ThePartnerInfo])
    }
    
    func loadSamplePartners() {
        let photo1 = UIImage(named: "Image-4")!
       // let photo2 = UIImage(named: "Image-2")!
        let photo3 = UIImage(named: "Image-5")!
        let partner1 = ThePartnerInfo(photo: photo1, name: "Andrew", surname: "Kibalnikov", mobileNumber: "0931526815", email: "anrewkibalnikov@gmail.com", currentBalance: 2000.00)
        //let partner2 = ThePartnerInfo(photo: photo2, name: "Max", surname: "Opirskyy", mobileNumber: "0931901947", email: "maher@gmail.com", currentBalance: -2500.20)
        let partner3 = ThePartnerInfo(photo: photo3, name: "Roman", surname: "Saveljev", mobileNumber: "0931526815", email: "romansavelyev@gmail.com", currentBalance: 3000.00)
        
        partners = [partner1, partner3]
    }

}
