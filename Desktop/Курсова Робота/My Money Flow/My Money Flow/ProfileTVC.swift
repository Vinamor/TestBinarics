//
//  ProfileTVC.swift
//  My Money Flow
//
//  Created by Ostap Romaniv on 5/25/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

import UIKit
import os.log

class ProfileTVC: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameSurname: UITextField!
    @IBOutlet weak var numberOfPartners: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    // MARK: - Properties
    var profile: Profile?
    let imagePicker = UIImagePickerController()
    // MARK: - IBActions
    @IBAction func setTheProfileImage(_ sender: UIButton) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(self.imagePicker, animated: true, completion: nil)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        nameSurname?.delegate = self
        
        makingLovelyEdges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
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

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}

extension ProfileTVC {
    // MARK: NSCoding
    fileprivate func saveProfileInfo() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(profile!, toFile: Profile.ArchieveURL!.path)
        if isSuccessfulSave {
            os_log("Profile successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save profile...", log: OSLog.default, type: .error)
        }
    }
    
    fileprivate func loadPartners() -> Profile {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Profile.ArchieveURL!.path) as? Profile)!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameSurname.resignFirstResponder()
        return true
    }
}

// MARK: - Profile Image Picker:
extension ProfileTVC {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImage.contentMode = .scaleToFill
        self.profileImage.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

typealias DesignMe = ProfileTVC
extension DesignMe {
    
    func makingLovelyEdges() {
        
        self.profileImage?.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage?.clipsToBounds = true
        self.profileImage?.layer.borderWidth = 0.25
        self.profileImage.layer.borderColor = UIColor.black.cgColor
        
        self.numberOfPartners.layer.cornerRadius = self.numberOfPartners.frame.size.height / 2
        self.numberOfPartners?.clipsToBounds = true
        self.numberOfPartners.layer.borderWidth = 0.25
        self.numberOfPartners.layer.borderColor = UIColor.black.cgColor
        
        self.balance.layer.cornerRadius = self.balance.frame.size.height / 2
        self.balance?.clipsToBounds = true
        self.balance.layer.borderWidth = 0.25
        self.balance.layer.borderColor = UIColor.black.cgColor
    }
}
