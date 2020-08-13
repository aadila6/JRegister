//
//  RegisterViewModel.swift
//  Jade
//
//  Created by Hamid Farooq on 15/12/2019.
//  Copyright © 2019 Hamid Farooq. All rights reserved.
//

import Foundation
//import RxSwift
//import RxCocoa
//import ProgressHUD

fileprivate struct Defaults {
    static let titleLabel = "Enter your phone number"
    static let titleDetailLabel = "We'll text a code to verify your number"
    static let titleFooterLabel = "By signing in you agree with the\nTerms and Conditions of Jade app"
    static let titlePlaceholderLabel = "Phone number"
    static let errorMessageLabel = "Phone number provided is invalid"

    #if DEBUG
        #if targetEnvironment(simulator)
            static let defaultNumberValue = "557072306"
        #else
            static let defaultNumberValue = "557072305"
        #endif
    #else
        static let defaultNumberValue = String()
    #endif
}

class RegisterViewModel {
    
    // MARK: - Properties
    
    var titleText: String { return Defaults.titleLabel }
    var detailText: String { return Defaults.titleDetailLabel }
    var footerText: String { return Defaults.titleFooterLabel }
    var placeholderText: String { return Defaults.titlePlaceholderLabel }
    var errorMessage: String { return Defaults.errorMessageLabel }
        
    
}

// MARK: - Network API Request

extension RegisterViewModel {
    
    func doRegister() {
//        guard let code = dialingCode.value, let phone = phone.value else { return }
//        let phoneNumber = code . + phone
        
//        ProgressHUD.show()
//        FirebaseManager.shared.authenticate(withPhone: phoneNumber, completion: { (otpToken, error) in
//            if let error = error {
//                self.alertDialog.onNext(("Title", error.localizedDescription))
//            }
//            else {
//                guard let otpToken = otpToken else { return }
//                self.didRegister.onNext((phoneNumber, otpToken))
//            }
//            ProgressHUD.dismiss()
//        })
    }
}
