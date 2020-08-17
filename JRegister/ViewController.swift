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
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    var viewModel : RegisterViewModel!
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    var countryImage = UIImage(systemName: "bell")!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberText.resignFirstResponder()
        self.NextButton.layer.cornerRadius = 20
        self.NextButton.backgroundColor = UIColor.green
        PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["US", "CA", "MX", "AU", "GB", "DE"]
        //        let image = UIImage(systemName: "phone")!
        setupIcon(countryImage)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //        self.phoneNumberText.leftView?.addGestureRecognizer(tap)
        //        self.phoneNumberText.leftView?.isUserInteractionEnabled = true
        self.viewModel = RegisterViewModel()
        PrepareViewModel()
    }
    
    func setupIcon(_ image: UIImage){
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        iconView.layer.cornerRadius = 30
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        self.phoneNumberText.leftView = iconContainerView
        self.phoneNumberText.leftViewMode = .always
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.phoneNumberText.leftView?.addGestureRecognizer(tap)
        self.phoneNumberText.leftView?.isUserInteractionEnabled = true
    }
    
    
    // function which is triggered when handleTap is called
    @objc func handleTap() {
        let pt = PhoneNumberKit()
        let vc = CountryCodePickerViewController(phoneNumberKit: pt)
        self.present(vc, animated: true, completion: nil)
//        pt.performSelector(onMainThread: <#T##Selector#>, with: <#T##Any?#>, waitUntilDone: <#T##Bool#>)
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
        print("Phone Numbe Entered: \(self.phoneNumberText.text)")
    }
}

//extension UITextField {
//
//    func setIcon(_ image: UIImage) {
//        let iconView = UIImageView(frame:
//            CGRect(x: 10, y: 5, width: 20, height: 20))
//        iconView.image = image
//        let iconContainerView: UIView = UIView(frame:
//            CGRect(x: 20, y: 0, width: 30, height: 30))
//        iconContainerView.addSubview(iconView)
//        leftView = iconContainerView
//        leftViewMode = .always
//    }
//
//}



