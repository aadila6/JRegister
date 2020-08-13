////
////  RegisterViewController.swift
////  Jade
////
////  Created by Hamid Farooq on 15/12/2019.
////  Copyright © 2019 Hamid Farooq. All rights reserved.
////
//
//import UIKit
////import RxSwift
////import RxCocoa
////import RxBiBinding
//
//fileprivate struct Defaults {
//    static let backgroundImage = #imageLiteral(resourceName: "loginBackground")
//    static let logoImage = #imageLiteral(resourceName: "rippleLogoSmall")
//    static let nextArrowImage = #imageLiteral(resourceName: "arrowRight")
//}
//
//class RegisterViewController: BaseViewControllerKeyboardHandler, Storyboarded {
//
//    // MARK: - IBOutlets
//
//    @IBOutlet weak var imageView: DesignableImageView!
//    @IBOutlet weak var logoImageView: DesignableImageView!
//    @IBOutlet weak var titleLabel: DesignableLabel!
//    @IBOutlet weak var detailLabel: DesignableLabel!
//    @IBOutlet weak var footerLabel: DesignableActiveLabel!
//    @IBOutlet weak var phoneTextField: DesignablePhoneTextField! {
//        didSet { phoneTextField.validationType = .onCommit }
//    }
//
//    @IBOutlet weak var nextButton: DesignableButton!
//    @IBOutlet weak var bottomSpaceHeightConstraint: NSLayoutConstraint!
//
//    // MARK: - Properties
//
//    var viewModel: RegisterViewModel!
//
//    // MARK: - Lifecycle
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Do any additional setup after awaking the view.
//        self.restorationIdentifier = RestorationID.registration
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        prepareViewModel()
//        prepareView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        configureNavigationBar()
//        _=phoneTextField.becomeFirstResponder()
//    }
//
//    override func keyboardWillShow(_ frame: CGRect) {
//        bottomSpaceHeightConstraint.constant = frame.size.height + padding
//    }
//
//    // MARK: - Action
//
//    @IBAction func nextButtonAction(_ sender: UIButton) {
//        try? phoneTextField.validate()
//
//        if phoneTextField.status == .normal {
//            viewModel.doRegister()
//        }
//    }
//}
//
//// MARK: - Private Functions
//
//extension RegisterViewController {
//
//    private func prepareViewModel() {
//        configureActivityIndicator(viewModel.loading)
//        configureAlertDialog(viewModel.alertDialog)
//    }
//
//    private func prepareView() {
////        imageView.image = Defaults.backgroundImage
////        logoImageView.image = Defaults.logoImage
//
//        titleLabel.text = viewModel.titleText
//        detailLabel.text = viewModel.detailText
//        footerLabel.text = viewModel.footerText
//        footerLabel.setActive(text: "Terms and Conditions", color: UIColor.Green!) { string in
//            print(string)
//        }
//
////        phoneTextField.placeholder = viewModel.placeholderText
//        phoneTextField.prepareAsTitleTextField()
//        phoneTextField.applyUnderlineStyle()
//        phoneTextField.delegate = self
//        phoneTextField.configureTextField(controller: self)
//
//        nextButton.setImage(Defaults.nextArrowImage, for: .normal)
//
//        titleLabel.prepareAsTitleLabel()
//        detailLabel.prepareAsDetailLabel(with: UIColor.Gray)
//        footerLabel.prepareAsFooterLabel(with: UIColor.Gray)
//
//        nextButton.prepareAsFilledButton()
//
//        /// UIControl Property Bindings
//        preparePropertyBindings()
////        prepareRxValidation()
//    }
//
//    internal override func configureNavigationBar() {
//        setNavigationBarWithBackButton()
//    }
//
//    private func preparePropertyBindings() {
//        (phoneTextField.rx.text <-> viewModel.phone)
//            .disposed(by: disposeBag)
//
//        (phoneTextField.dialingCode <-> viewModel.dialingCode)
//        .disposed(by: disposeBag)
//    }
//
////    private func prepareRxValidation() {
////        let phoneValid: Observable<Bool> = phoneTextField.rx.text
////            .map { text -> Bool in
////                return text!.count > 0
////        }
////        .share(replay: 1)
////
////        phoneValid
////            .bind(to: nextButton.rx.isEnabled)
////            .disposed(by: disposeBag)
////    }
//}
//
//// MARK: - UnderLineTextField Delegate
//
//extension RegisterViewController: UnderlineTextFieldDelegate {
//
//    func textFieldValidate(underLineTextField: UnderlineTextField) throws {
//        if phoneTextField.text?.isPhoneNumber == false {
//            throw UnderlineTextFieldErrors.error(message: viewModel.errorMessage)
//        }
//    }
//
//    func textFieldTextChanged(underLineTextField: UnderlineTextField) {
//        underLineTextField.status = .normal
//    }
//}
