//
//  ViewController.swift
//  JRegister
//
//  Created by Adila on 8/11/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import ContactsUI
import UnderLineTextField
import PhoneNumberKit

class ViewController: UIViewController, CountryCodeDelegate, UITextFieldDelegate, UnderLineTextFieldDelegate {
    
    var pnTextField : PhoneNumberTextField!
    var viewModel : RegisterViewModel!
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    var countryImage = UIImage(systemName: "bell")!
    var country : Country!
    var leftText : String = "🇺🇸 +1"
    var label : UILabel!
    private var keyboardObserver: KeyboardObserver!
    let vc = CPTableViewController()
    private lazy var _defaultRegion: String = PhoneNumberKit.defaultRegionCode()
    var counter = 0
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!
    @IBOutlet weak var phoneNumberText: PhoneNumberTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var underline: UnderLineTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        initDelegates()
        initUI()
        initTextFields()
    }
    
    func initDelegates() {
        self.underline.delegate = self
        self.underline.validationType = .always
        self.vc.delegate = self
        self.phoneNumberText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func initTextFields() {
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: self.phoneNumberText.frame.height))
        
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: self.phoneNumberText.frame.height))
        label.text = self.leftText
        label.textColor = UIColor.black
        
        leftPaddingView.addSubview(self.label)
        leftPaddingView.translatesAutoresizingMaskIntoConstraints = true
        self.phoneNumberText.leftView = leftPaddingView
        self.phoneNumberText.leftViewMode = .always
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.phoneNumberText.leftView?.addGestureRecognizer(tap)
        self.phoneNumberText.leftView?.isUserInteractionEnabled = true
    }
    
    func initUI() {
        PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["US", "CA", "MX", "AU", "CN"]
        self.phoneNumberText.resignFirstResponder()
        self.nextButton.layer.cornerRadius = 20
        self.nextButton.backgroundColor = UIColor.green
        self.underline.errorTextColor = UIColor.red

    }
    
    func initViewModel() {
        self.viewModel = RegisterViewModel()
        TitleLabel.text = viewModel.titleText
        SubtitleLabel.text = viewModel.detailText
        footerLabel.text = viewModel.footerText
        //                   footerLabel.setActive(text: "Terms and Conditions", color: UIColor.green) { string in
        //                       print(string)
        //                   }
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        print("Next button pushed")
    }
    
    // MARK: Country TableView Handler
    @objc func handleTap() {
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: UnderlineTextField Delegate
    func textFieldValidate(underLineTextField: UnderLineTextField) throws {
        print("DEBUG: validating input number")
        counter = counter + 1
        throw UnderLineTextFieldErrors
            .error(message: "Error message \(counter)")
        //throw UnderLineTextFieldErrors
            //.warning(message: "warning message")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextTextField = view.viewWithTag(textField.tag + 1) else {
            view.endEditing(true)
            return false
        }
        _ = nextTextField.becomeFirstResponder()
        return false
    }
    
    // MARK: UITextField/UnderlineTextField Delegate Handler
    @objc func textFieldDidChange(underLineTextField: UnderLineTextField) {
        print("DEBUG: changing from underline delegate")
        let error: ()? = try? self.underline.validate()
        guard error != nil else {
            return
        }
    }
    
    //    @objc func textFieldDidChange(_ textField: UITextField) {
    //        print("DEBUG: changing from UItextField delegate")
    //        self.underline.text = textField.text
    //    }
    
    // MARK: Country Table View Picker Delegate
    func CPTableViewControllerDidPickCountry(_ country: CPTableViewController.Country) {
        self.leftText = "\(country.flag) \(country.prefix)"
        self.label.text = self.leftText
        
    }
}

