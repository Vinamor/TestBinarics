//
//  ForgotPasswordViewController.swift
//  BibleApp
//
//  Created by Ostap Romaniv on 4/25/17.
//  Copyright © 2017 Igor Makara. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var blurEffectView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var confirmEmail: RoundedButton!
    @IBOutlet weak var checkPassCode: RoundedButton!
    @IBOutlet weak var confirmEmailView: UIView!
    
    @IBOutlet weak var confirmEmailTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmEmailLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkPassCodeTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkPassCodeLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var checkPassCodeTxtFld_1: RoundedTextField!
    @IBOutlet weak var checkPassCodeTxtFld_2: RoundedTextField!
    @IBOutlet weak var checkPassCodeTxtFld_3: RoundedTextField!
    @IBOutlet weak var checkPassCodeTxtFld_4: RoundedTextField!
    
    @IBOutlet weak var passCodeViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var passCodeViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var designView: UIView!
    
    
    // MARK: - Properties
    var userData: User?
    var userID: Int?
    
    
    // MARK: - Forgot Password View Controller`s life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // functions called
        
        
        // styling
        setUpBlurEffect()
        styleEmailTxtFld() 
        
        // initial values for constraints
        initialConstraints()
        
        // initial visibility of UI objects
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBActions
    @IBAction func confirmEmailPressed(_ sender: UIButton) {
        
        self.displayAlert(userMessage: "The passcode was sent to you email, check it and write in!")
        
        if (self.email.text == "") {
            self.displayAlert(userMessage: "Input email, please")
        } else if let email = self.email.text {
            User.confirmEmail(email: email, completion: { userInfo, error in
                self.animateForgotPasswordScreen()
                
                if let user = userInfo {
                    self.userData = user
                    
                } else if let error = error {
                    
                    self.displayAlert(userMessage: "🔴Something went wrong! Look to the Debug Area!")
                    print("🔴🔴🔴 \(error) 🔴🔴🔴")
                    
                }
            })
        }
    }

    @IBAction func checkPassCodePressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "checkPassCodeID", sender: self)

        
//        if (checkPassCodeTxtFld_1.text == "" || checkPassCodeTxtFld_2.text == "" || checkPassCodeTxtFld_3.text == "" || checkPassCodeTxtFld_4.text == ""){
//            self.displayAlert(userMessage: "You can't leave empty fields")
//        } else if let num1 = checkPassCodeTxtFld_1.text, let num2 = checkPassCodeTxtFld_2.text, let num3 = checkPassCodeTxtFld_3.text, let num4 = checkPassCodeTxtFld_4.text {
//            let code = num1+num2+num3+num4
//            User.checkThePassCode(code: code, completion: { userInfo, error in
//                
//                if let user = userInfo {
//                    
//                    self.userData = user
//                    
//                    self.performSegue(withIdentifier: "checkPassCodeID", sender: self)
//                }  else if let error = error {
//                    
//                    self.displayAlert(userMessage: "🔴Something went wrong! Look to the Debug Area!")
//                    print("🔴🔴🔴 \(error) 🔴🔴🔴")
//                    
//                }
//            })
//        }
    }
    
    
    @IBAction func comeBackToLogIn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkPassCodeID" {
            
            let newPasswordViewController = segue.destination as! NewPasswordViewController
            
            newPasswordViewController.userID = self.userID
            newPasswordViewController.userData = self.userData
        }
    }
    
}

extension ForgotPasswordViewController {
    
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
    
    fileprivate func animateForgotPasswordScreen() {
        UIView.animate(withDuration: 1, delay: 0.3, options: [.allowAnimatedContent], animations: {
            
            self.confirmEmailView.isHidden = self.confirmEmailView.isHidden ? false : true
            
            self.confirmEmailLeadingConstraint.constant = -self.view.frame.width
            self.confirmEmailTrailingConstraint.constant = self.view.frame.width*2
            
            self.passCodeViewLeadingConstraint.constant = -self.view.frame.width
            self.passCodeViewTrailingConstraint.constant = self.view.frame.width*2
            
            self.checkPassCodeLeadingConstraint.constant = 57
            self.checkPassCodeTrailingConstraint.constant = 57
            
            self.passCodeViewLeadingConstraint.constant = 0
            self.passCodeViewTrailingConstraint.constant = 0
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func initialConstraints() {
        checkPassCodeLeadingConstraint.constant = self.view.frame.width
        checkPassCodeTrailingConstraint.constant = -self.view.frame.width
        
        passCodeViewLeadingConstraint.constant = self.view.frame.width
        passCodeViewTrailingConstraint.constant = -self.view.frame.width
    }
    
    fileprivate func displayAlert(userMessage: String) {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func styleEmailTxtFld() {
        self.email.attributedPlaceholder = NSMutableAttributedString(string: "Email", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.black])
    }
}
