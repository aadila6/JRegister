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

class ViewController: UIViewController, CountryCodeDelegate {
    
    func CPTableViewControllerDidPickCountry(_ country: CPTableViewController.Country) {
        print("hahahahaha \(country)")
        print("\(country.flag) \(country.prefix) ")
        var a = " "
        var b = " "
        
        if country.flag != nil {
            print(country.flag)
            a = country.flag
//            print(a)
        }
        if country.prefix != nil {
            print(country.prefix)
            b = country.prefix
//            print(b)
        }
        self.leftText = "\(a) \(b)"
        self.label.text = self.leftText
        print("Left Text: \(self.leftText)")
    }
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    private lazy var _defaultRegion: String = PhoneNumberKit.defaultRegionCode()
    var viewModel : RegisterViewModel!
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    var countryImage = UIImage(systemName: "bell")!
    var country : Country!
    var leftText : String = "🇺🇸 +1"
    var label : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupIcon(countryImage)
        self.phoneNumberText.rightView?.becomeFirstResponder()
        self.viewModel = RegisterViewModel()
        PrepareViewModel()
    }
    
    func setupIcon(_ image: UIImage) {
        //        let iconView = UIImageView(frame:
//            CGRect(x: 10, y: 5, width: 20, height: 20))
//        iconView.image = image
//        iconView.layer.cornerRadius = 50
//        let iconContainerView: UIView = UIView(frame:
//            CGRect(x: 20, y: 0, width: 30, height: 30))
//        //        iconContainerView.addSubview(iconView)
//        iconContainerView.backgroundColor = UIColor.red
//        iconContainerView.layer.cornerRadius = 15

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: self.phoneNumberText.frame.height-10))
        paddingView.backgroundColor = UIColor.yellow
        
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: self.phoneNumberText.frame.height-10))

        label.text = self.leftText
        label.textColor = UIColor.black
        
        paddingView.addSubview(self.label)
        
        self.phoneNumberText.leftView = paddingView
        self.phoneNumberText.leftViewMode = .always
        
        // Left view
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.phoneNumberText.leftView?.addGestureRecognizer(tap)
        self.phoneNumberText.leftView?.isUserInteractionEnabled = true
        
        // Right view
        let key = UITapGestureRecognizer(target: self, action: #selector(handleTap2))
        self.phoneNumberText.rightView?.addGestureRecognizer(key)
        self.phoneNumberText.rightView?.isUserInteractionEnabled = true
        
    }
    
    
    
    func setupUI() {
        
        PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["US", "CA", "MX", "AU", "GB"]
        self.phoneNumberText.resignFirstResponder()
        self.NextButton.layer.cornerRadius = 20
        self.NextButton.backgroundColor = UIColor.green
    }
    
    var containingViewController: UIViewController? {
        var responder: UIResponder? = self
        while !(responder is UIViewController) && responder != nil {
            responder = responder?.next
        }
        return (responder as? UIViewController)
    }
    
    
    
    @objc func handleTap() {
        let vc = CPTableViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func handleTap2() {
        self.phoneNumberText.resignFirstResponder()
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


