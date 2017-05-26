//
//  SignInViewController.swift
//  BibleApp
//
//  Created by Mac on 4/20/17.
//  Copyright © 2017 Igor Makara. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Google
import GoogleSignIn

class SignInViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var contentProviderView: UIView!
    @IBOutlet weak var contentProviderText: UILabel!
    
    @IBOutlet weak var signUpByEmail: UIButton!
    @IBOutlet weak var signInbyEmail: UIButton!
    
    @IBOutlet weak var googleSignUp: RoundedButton!
    @IBOutlet weak var googleSignIn: RoundedButton!
    
    @IBOutlet weak var facebookLogIn: RoundedButton!
    @IBOutlet weak var facebookSignUp: RoundedButton!
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    @IBOutlet weak var bluerEffectView: UIView!
    @IBOutlet weak var underlinedView: UIView!
    
    @IBOutlet weak var designView: UIView!
    
    
    @IBOutlet var underlinedViewAllignCenterToSignUpButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpWithEmailView: UIView!
    
    @IBOutlet weak var signUpViewLeadings: NSLayoutConstraint!
    @IBOutlet weak var signUpViewTrailings: NSLayoutConstraint!
    
    @IBOutlet weak var loginInViewTrailings: NSLayoutConstraint!
    @IBOutlet weak var loginInViewLeadings: NSLayoutConstraint!
    
    
    // MARK: - Properties
    var userData: User?
    var userID: Int?
    let defaults = UserDefaults.standard
    var isUserLoginIn = true
    fileprivate var content_type: String?
    
    let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        return button
    }()
    
    let facebookLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        return button
    }()
    

    // MARK: - Sign In View Controller`s life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // functions called
        
        // configuration for login systems
        facebookLoginButton.delegate = self
        googleSingInConfiguration()
        
        // styling
        self.setUpBlurEffect()
        self.styleTheButton()
        styleTheLoginView()
        self.buttonText()
        signUpWithEmailView.isHidden = true
        
        // init values for constraints
        signUpViewLeadings.constant = view.frame.width
        signUpViewTrailings.constant = -view.frame.width
    }

    
    // MARK: - IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        isUserLoginIn = false
        
        if !signUpWithEmailView.isHidden {
            signUpWithEmailView.isHidden = true
        }
        
        if email.text != "" && password.text != "" {
            signUpWithEmail()
            
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.allowAnimatedContent], animations: {
            self.underlinedViewAllignCenterToSignUpButtonConstraint.priority = 20
            
            self.loginInViewLeadings.constant = -self.view.frame.width
            self.loginInViewTrailings.constant = self.view.frame.width * 2
            
            self.signUpViewTrailings.constant = 0
            self.signUpViewLeadings.constant = 0
            
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //isUserLoginIn = true
        
        if email.text == "" || password.text == "" {
            
            if !signUpWithEmailView.isHidden {
                signUpWithEmailView.isHidden = true
//                contentProviderView.isHidden = true
            }
        } else {
            enterInSystemByEmail()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.allowAnimatedContent], animations: {
            self.underlinedViewAllignCenterToSignUpButtonConstraint.priority = 998
            
            self.loginInViewLeadings.constant = 0
            self.loginInViewTrailings.constant = 0
            
            self.signUpViewLeadings.constant = self.view.frame.width
            self.signUpViewTrailings.constant = -self.view.frame.width
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func signUpbyEmailAction(_ sender: UIButton) {
        signUpWithEmailView.isHidden = signUpWithEmailView.isHidden ? false : true
    }
    @IBAction func signInEmailAction(_ sender: UIButton) {
        
        signUpWithEmailView.isHidden = signUpWithEmailView.isHidden ? false : true
    }
    
    @IBAction func facebookSignInAction(_ sender: UIButton) {
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func googleSignInAction(_ sender: UIButton) {
        googleLoginButton.sendActions(for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forgotPasswordID" {
            let forgotPasswordViewController = segue.destination as! ForgotPasswordViewController
            forgotPasswordViewController.userData = self.userData
            forgotPasswordViewController.userID = self.userID
        }
    }
    
}

// MARK: - Extensions
private typealias FacebookDelegate = SignInViewController
extension FacebookDelegate: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let token = FBSDKAccessToken.current() {
            User.loginFacebook(token: token.tokenString, completion: { (userInfo, error) in
                
                if let user = userInfo {
                    self.userData = user
                    self.loadApp()
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}

private typealias GoogleDelegate = SignInViewController
extension GoogleDelegate: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        User.loginGoogle(id: signIn.clientID, email: user.profile.email) { (userInfo, error) in
            
            if error != nil {
                print("Error in Google")
            }
            
            if let user = userInfo {
                self.userData = user
                self.loadApp()
            }
        }
    }
    
}

private typealias ConfigurationSingInController = SignInViewController
extension ConfigurationSingInController {
    
    fileprivate func googleSingInConfiguration() {
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        if configureError != nil {
            print("🚨🚨🚨 Error with GGLContext")
        }
        
        // set google login delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    
    fileprivate func setUpBlurEffect() {
        
        let blurEffect1 = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffect2 = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        let blurEffectView1 = UIVisualEffectView(effect: blurEffect1)
        let blurEffectView2 = UIVisualEffectView(effect: blurEffect2)
        
        blurEffectView1.frame = bluerEffectView.bounds
        blurEffectView1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        blurEffectView2.frame = designView.bounds
        blurEffectView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        bluerEffectView.addSubview(blurEffectView1)
        designView.addSubview(blurEffectView2)
    }
}

private typealias TextFieldDelegate = SignInViewController
extension TextFieldDelegate: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private typealias OtherHelpfullMethods = SignInViewController
extension OtherHelpfullMethods {
    fileprivate func enterInSystemByEmail() {
        
        User.login(withEmail: email.text!, password:  password.text! , completion: { userInfo, error in
            
            if let user = userInfo, let email = userInfo?.email  {
                self.userData = user
                self.userID = user.id
                
                if (email == self.email.text!) {
                    self.loadApp()
                    
                    self.defaults.set(true, forKey: isUserLogenInKey)
                    self.defaults.set(user.email, forKey: userEmailKey)
                    self.defaults.set(user.id!, forKey: userIDKey)
                    
                } else {
                    self.displayAlert(userMessage: "Password or email is incorrect!!! \n Try Once More!")
                }
            } else {
                self.displayAlert(userMessage: "You need to sign up first! There was no user with such username!")
            }
        })
    }
    
    fileprivate func signUpWithEmail() {
        
        let defaultContentType = "user"
        
        User.signUpWithEmail(email: email.text!,
                             password: password.text!,
                             phone: phone.text ?? "00000000",
                             content_type: self.content_type ?? defaultContentType ,
                             completion: { (userInfo, error) in
            if error != nil {
                print("Sign Up with email is fail")
            }
            
            if let user = userInfo, let token = userInfo?.token {
                self.userData = user

                self.defaults.set(token, forKey: "userToken")
                
                self.defaults.set(true, forKey: isUserLogenInKey)
                self.defaults.set(user.email, forKey: userEmailKey)
                self.defaults.set(user.id!, forKey: userIDKey)
                
                self.loadApp()
            }
        })
        
    }
    
    fileprivate func loadApp() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        
        self.show(controller, sender: self)
    }
    
    fileprivate func displayAlert(userMessage: String) {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func styleTheButton() {
        
        self.signInbyEmail.layer.borderWidth = 1
        self.signInbyEmail.layer.borderColor = UIColor.lightGray.cgColor
        self.signUpByEmail.layer.borderWidth = 1
        self.signUpByEmail.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    fileprivate func buttonText() {
        
        var attributedGoogleButtonText1 = NSMutableAttributedString()
        var attributedGoogleButtonText2 = NSMutableAttributedString()
        var attributedFacebookButtonText1 = NSMutableAttributedString()
        var attributedFacebookButtonText2 = NSMutableAttributedString()
        
        //if googleSignIn.becomeFirstResponder()
        
        attributedGoogleButtonText1 = NSMutableAttributedString(string: "Sign Up With ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22), NSForegroundColorAttributeName: UIColor.black])
        
        attributedGoogleButtonText2 = NSMutableAttributedString(string: "Log In With ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 22), NSForegroundColorAttributeName: UIColor.black])
        
        attributedGoogleButtonText1.append(NSAttributedString(string: "G+", attributes : [NSFontAttributeName: UIFont(name: "Arial", size: 30.0)!, NSForegroundColorAttributeName: UIColor.red]))
        
        attributedGoogleButtonText2.append(NSAttributedString(string: "G+", attributes : [NSFontAttributeName: UIFont(name: "Arial", size: 30.0)!, NSForegroundColorAttributeName: UIColor.red]))
        
        
        attributedFacebookButtonText1 = NSMutableAttributedString(string: "f", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 35),  NSForegroundColorAttributeName: UIColor.white])
        
        attributedFacebookButtonText2 = NSMutableAttributedString(string: "f", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 35), NSForegroundColorAttributeName: UIColor.white])
        
        attributedFacebookButtonText1.append(NSAttributedString(string: " Sign Up With Facebook", attributes : [NSFontAttributeName: UIFont.systemFont(ofSize: 22),  NSForegroundColorAttributeName: UIColor.white]))
        
        attributedFacebookButtonText2.append(NSAttributedString(string: " Login With Facebook", attributes : [NSFontAttributeName: UIFont.systemFont(ofSize: 22), NSForegroundColorAttributeName: UIColor.white]))
        
        
        self.googleSignUp.setAttributedTitle(attributedGoogleButtonText1, for: .normal)
        self.googleSignIn.setAttributedTitle(attributedGoogleButtonText2, for: .normal)
        self.facebookSignUp.setAttributedTitle(attributedFacebookButtonText1, for: .normal)
        self.facebookLogIn.setAttributedTitle(attributedFacebookButtonText2, for: .normal)
       
    }
    
    fileprivate func styleTheLoginView() {
        self.email.attributedPlaceholder = NSMutableAttributedString(string: "Email", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.black])
        self.password.attributedPlaceholder = NSMutableAttributedString(string: "Password", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.black])
        self.phone.attributedPlaceholder = NSMutableAttributedString(string: "Phone", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.black])
    }

}
