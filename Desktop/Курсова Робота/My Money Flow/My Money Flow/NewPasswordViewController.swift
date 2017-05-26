//
//  NewPasswordViewController.swift
//  BibleApp
//
//  Created by Ostap Romaniv on 4/27/17.
//  Copyright © 2017 Igor Makara. All rights reserved.
//

import UIKit
import Alamofire

class NewPasswordViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var newPasswordTxtFld: UITextField!
    @IBOutlet weak var confirmNewPasswordTxtFld: UITextField!
    @IBOutlet weak var blurEffectView: UIView!
    @IBOutlet weak var createNewPassword: RoundedButton!
    
    @IBOutlet weak var designView: UIView!
    
    // MARK: - Properties
    var userData: User?
    var userID: Int?
    
    // MARK: - New Password View Controller`s life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // functions called
        
        // styling
        setUpBlurEffect()
        styleNewPasswordTxtFld()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func createNewPasswordPressed(_ sender: UIButton) {
        
        if newPasswordTxtFld.text == "" || confirmNewPasswordTxtFld.text == "" {
            
            self.displayAlert(userMessage: "Type in the password and confirm it!")
            
        } else {
            if newPasswordTxtFld.text == confirmNewPasswordTxtFld.text {
                if let id = self.userID, let newPassword = self.newPasswordTxtFld.text {
                    User.confirmNewPassword(user_id: id, newPassword: newPassword, completion: { userInfo, error in
                        
                        if let user = userInfo {
                            print("🔴\(user.message)")
                            self.loadApp()
                            
                            
                        } else if let error = error {
                            
                            self.displayAlert(userMessage: "An Error occurred! Look to the Debug Area!")
                            print("🔴🔴🔴 \(error) 🔴🔴🔴")
                        }
                    })
                }
            } else {
                self.displayAlert(userMessage: "The passwords do not match! Try again!")
            }
        }
    }
    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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


// MARK: - Extensions
extension NewPasswordViewController {
    
    fileprivate func setUpBlurEffect() {
        
        let blurEffect1 = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView1 = UIVisualEffectView(effect: blurEffect1)
        
        blurEffectView1.frame = self.blurEffectView.bounds
        blurEffectView1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let blurEffect2 = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView2 = UIVisualEffectView(effect: blurEffect2)
        
        blurEffectView2.frame = self.designView.bounds
        blurEffectView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        self.blurEffectView.addSubview(blurEffectView1)
        self.designView.addSubview(blurEffectView2)
    }
    
    fileprivate func displayAlert(userMessage: String) {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func loadApp() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        
        self.show(controller, sender: self)
    }
    
    fileprivate func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    fileprivate func styleNewPasswordTxtFld() {
        self.newPasswordTxtFld.attributedPlaceholder = NSMutableAttributedString(string: "New Password", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.black])
        self.confirmNewPasswordTxtFld.attributedPlaceholder = NSMutableAttributedString(string: "Confirm Password", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.black])
    }
    
}
