//
//  ViewController.swift
//  JRegister
//
//  Created by Adila on 8/11/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import UnderLineTextField
import PhoneNumberKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!
    @IBOutlet weak var phoneNumberText: PhoneNumberTextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    var viewModel : RegisterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberText.resignFirstResponder()
        self.NextButton.layer.cornerRadius = 20
        self.NextButton.backgroundColor = UIColor.green
        
        PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["US", "CA", "MX", "AU", "GB", "DE"]
        // MARK: - Add CountryPicker Here
        let countryPickerView = UIView()
        countryPickerView.backgroundColor = UIColor.yellow
        self.phoneNumberText.leftView = countryPickerView
        self.phoneNumberText.leftViewMode = .always
        phoneNumberText.withFlag = true
        
        self.viewModel = RegisterViewModel()
        PrepareViewModel()
    }
    
    func PrepareViewModel() {
        TitleLabel.text = viewModel.titleText
        SubtitleLabel.text = viewModel.detailText
        footerLabel.text = viewModel.footerText
//        footerLabel.setActive(text: "Terms and Conditions", color: UIColor.green) { string in
//            print(string)
//        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        print("Next button pushed")
        
    }
    
    
}


