//
//  AccountLoginViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit

class AccountLoginViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel = AccountLoginViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet var loginFormEmail: UITextField!
    @IBOutlet var loginFormPassword: UITextField!
    @IBOutlet var validationStatusLabel: UILabel!
    
    private var validatorObj: Validation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validatorObj = Validation()
        
        loginFormEmail.ajw_attachValidator(validatorObj.emailValidator(validationStatusLabel))
        loginFormPassword.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Insert Your Password!", integerforMinLength: 1, minLengthErrorMessage: "It can't be just nothing!", withLabelForValidationRules: validationStatusLabel))
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.loginState.bind { [weak self] state in
            guard let self = self else { return }
            self.handleLoginState(state)
        }
    }
    
    private func handleLoginState(_ state: LoginState) {
        switch state {
        case .idle:
            break
        case .loading:
            break
        case .success:
            navigationController?.popToRootViewController(animated: true)
        case .offlineMode:
            viewModel.showOfflineNotification(on: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        case .error(let message):
            generalAlerts("Alert!", withMessage: message, withYesActionTitle: "Cancel Log In!", withNoActionTitle: "Back to Login!")
        }
    }
    
    @IBAction func loginFormSignInButton(_ sender: UIButton) {
        guard loginFormEmail.hasText && loginFormPassword.hasText else {
            generalAlerts("Empty Form!", withMessage: "Give your Email and Password", withYesActionTitle: "Cancel Log In", withNoActionTitle: "Ok!")
            return
        }
        
        guard viewModel.validateEmail(loginFormEmail.text ?? "") else {
            generalAlerts("Invalid Email!", withMessage: "Please Insert a valid email address", withYesActionTitle: "Cancel Log In", withNoActionTitle: "Ok!")
            return
        }
        
        viewModel.email.value = loginFormEmail.text ?? ""
        viewModel.password.value = loginFormPassword.text ?? ""
        
        viewModel.login { [weak self] success in
            guard let self = self else { return }
            if success {
                if self.viewModel.loginState.value == .offlineMode {
                    sender.setTitle("Demo Mode", for: .normal)
                    sender.backgroundColor = .orange
                } else {
                    sender.setTitle("Logged In", for: .normal)
                    sender.backgroundColor = .green
                }
            } else {
                sender.setTitle("Try Again", for: .normal)
            }
        }
    }
    
    func generalAlerts(_ alertTitle: String, withMessage alertMessage: String, withYesActionTitle yesActionTitle: String, withNoActionTitle noActionTitle: String) {
        let generalAlert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        let noAction = UIAlertAction(title: yesActionTitle, style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        let yesAction = UIAlertAction(title: noActionTitle, style: .default, handler: nil)
        
        generalAlert.addAction(yesAction)
        generalAlert.addAction(noAction)
        present(generalAlert, animated: true, completion: nil)
    }
}
