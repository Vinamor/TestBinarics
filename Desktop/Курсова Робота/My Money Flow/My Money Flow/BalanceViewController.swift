//
//  BalanceViewController.swift
//  My Money Flow
//
//  Created by Ostap Romaniv on 06.12.16.
//  Copyright © 2016 Ostap Romaniv. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {
 
    // MARK: - IBOutlets:
    @IBOutlet weak var theSumTextField: UITextField?
    @IBOutlet weak var theDatePicker: UIDatePicker?
    @IBOutlet weak var saveButton: UIBarButtonItem!
 
    @IBOutlet weak var blurEffect: UIView!
    
    // MARK: - Properties:
    var note: TheReportNote?
    var backController: BalanceTableViewController?
    
    
    // MARK: - View Controller life-cycle:
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setUpBlurEffect()
        
        if let note = note, let nS = note.sum, let nD = note.date {
            
            theSumTextField?.text = String(describing: nS)
            theDatePicker?.date = nD
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IBActions
    @IBAction func saveMonetaryEvent(_ sender: UIBarButtonItem) {
        let isPresentingInAddNoteMode = presentingViewController is UINavigationController
        
        if isPresentingInAddNoteMode {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let date = theDatePicker?.date
        
        let sumHelper: Int? = (Int)((theSumTextField?.text)!) ?? 0
        let sum: Decimal? = (Decimal)((sumHelper)!) 
        
        note = TheReportNote(date: date, sum: sum)
    }
    
    fileprivate func setUpBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.blurEffect.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.blurEffect.addSubview(blurEffectView)
    }

}
