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



class ViewController: UIViewController, CountryCodeDelegate{
    
    func CPTableViewControllerDidPickCountry(_ country: CPTableViewController.Country) {
        print("hahahahaha \(country)")
    }
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!
    @IBOutlet weak var phoneNumberText: UnderLineTextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    private lazy var _defaultRegion: String = PhoneNumberKit.defaultRegionCode()
    var viewModel : RegisterViewModel!
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    var countryImage = UIImage(systemName: "bell")!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupIcon(countryImage)
        self.viewModel = RegisterViewModel()
        PrepareViewModel()
    }
    
    func setupIcon(_ image: UIImage){
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        iconView.layer.cornerRadius = 50
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        iconContainerView.backgroundColor = UIColor.red
        iconContainerView.layer.cornerRadius = 15
        self.phoneNumberText.leftView = iconContainerView
        self.phoneNumberText.leftViewMode = .always
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.phoneNumberText.leftView?.addGestureRecognizer(tap)
        self.phoneNumberText.leftView?.isUserInteractionEnabled = true
        let key = UITapGestureRecognizer(target: self, action: #selector(handleTap2))
        self.phoneNumberText.rightView?.addGestureRecognizer(key)
    }
    
    func setupUI(){
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


