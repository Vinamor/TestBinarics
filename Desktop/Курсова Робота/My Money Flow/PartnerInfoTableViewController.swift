//
//  PartnerInfoTableViewController.swift
//  My Money Flow
//
//  Created by Marta Romaniv on 03.12.16.
//  Copyright © 2016 Ostap Romaniv. All rights reserved.
//

import UIKit

class PartnerInfoTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PayPalPaymentDelegate {
    
    // MARK: - IBOutlets:
    @IBOutlet weak var PartnerImage: UIImageView!
    @IBOutlet weak var PartnerNameSurname: UITextField!
    @IBOutlet weak var PartnerMobileNumber: UITextField!
    @IBOutlet weak var PartnerEmail: UITextField!
    @IBOutlet weak var PartnerBalance: UILabel!
    @IBOutlet weak var balanceButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var settleUpBtn: UIButton!
    
    // MARK: - Properties:
    var partner: ThePartnerInfo?
    var numberOfRows: Int?
    var backController: UITableViewController?
    let imagePicker = UIImagePickerController()
    var payPalConfig = PayPalConfiguration()
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }

    // MARK: - IBActions:
    @IBAction func importPhoto(_ sender: UIButton) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func paymentConduction(_ sender: UIButton) {
        // Optional: include multiple items
        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "1000.00"), withCurrency: "USD", withSku: "Hip-0037")
        let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "1000.00"), withCurrency: "USD", withSku: "Hip-00066")
        let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "500.00"), withCurrency: "USD", withSku: "Hip-00291")
        
        let items = [item1, item2, item3]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Money for Trump", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }

    }
    
    
    // MARK: - View Controller Life-cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makingLovelyEdges()
    
        
        // MARK: - calling delegates
        imagePicker.delegate = self
        
        PartnerNameSurname?.delegate = self
        PartnerMobileNumber?.delegate = self
        PartnerEmail?.delegate = self
        
        
        if let partner = partner, let pN = partner.name, let pS = partner.surname, let pI = partner.photo, let pMN = partner.mobileNumber, let pE = partner.email, let cb = partner.currentBalance {
            
            PartnerNameSurname.text = pN + " " + pS
            PartnerImage?.image = pI
            PartnerMobileNumber?.text = pMN
            PartnerEmail?.text = pE
            PartnerBalance?.text = String(describing: cb)
        }
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Private Inc."
        
        // PayPal Merchant Policy
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        payPalConfig.payPalShippingAddressOption = .payPal
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
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
        
        if let numberOfRows = self.numberOfRows {
        return numberOfRows
        } else {
            return 4
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "balanceId" {
            let destination = segue.destination as? UINavigationController
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BalanceTableViewController") as! BalanceTableViewController

            destination?.setViewControllers([controller], animated: true)
        }
        
        let photo = PartnerImage?.image
        let nameSurname = PartnerNameSurname?.text ?? ""
        let mobile = PartnerMobileNumber?.text ?? " "
        let email = PartnerEmail?.text ?? ""
        let balance: Int? = (Int)((PartnerBalance?.text)!) ?? 0
        let helper: Decimal = (Decimal)(balance!)
        
        partner = ThePartnerInfo(photo: photo, name: nameSurname, surname: "", mobileNumber: mobile, email: email, currentBalance: helper)
    }
    
}

typealias Design = PartnerInfoTableViewController
extension Design {
    
    func makingLovelyEdges() {
    
        self.PartnerImage?.layer.cornerRadius = self.PartnerImage.frame.size.width / 2
        self.PartnerImage?.clipsToBounds = true
        self.PartnerImage?.layer.borderWidth = 0.25
        self.PartnerImage.layer.borderColor = UIColor.black.cgColor
        
        self.balanceButton.layer.cornerRadius = 30
        self.balanceButton.layer.borderWidth = 0.25
        self.balanceButton.layer.borderColor = UIColor.black.cgColor
        
        self.settleUpBtn.layer.cornerRadius = 30
        self.settleUpBtn.layer.borderWidth = 0.25
        self.settleUpBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    fileprivate func setUpBlurEffect() {
        // Add a background view to the table view
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        //blurEffectView.frame = (self.tableView.backgroundView?.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.tableView.backgroundView?.addSubview(blurEffectView)
    }


}

// MARK: - PayPal:
extension PartnerInfoTableViewController {
    internal func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        
        print("🔴 PayPal Payment Cancelled 🔴")
        
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    internal func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("🔴 Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment. 🔴")
        })
    }
}

// MARK: - Profile Image Picker:
extension PartnerInfoTableViewController {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.PartnerImage.contentMode = .scaleToFill
        self.PartnerImage.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        PartnerNameSurname.resignFirstResponder()
        PartnerMobileNumber.resignFirstResponder()
        PartnerEmail.resignFirstResponder()
        return true
    }
}

