//
//  AccountLoginViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import UIKit

class AccountLoginViewController: UIViewController {
    
    @IBOutlet var loginFormEmail: UITextField!
    @IBOutlet var loginFormPassword: UITextField!
    @IBOutlet var validationStatusLabel: UILabel!
    
    private var accountOperationsObj: AccountOperations!
    private var validatorObj: Validation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountOperationsObj = AccountOperations()
        validatorObj = Validation()
        
        loginFormEmail.ajw_attachValidator(validatorObj.emailValidator(validationStatusLabel))
        loginFormPassword.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Insert Your Password!", integerforMinLength: 1, minLengthErrorMessage: "It can't be just nothing!", withLabelForValidationRules: validationStatusLabel))
    }
    
    func loginAction(_ sender: UIButton) {
        let encryptedPassword = accountOperationsObj.sha1(loginFormPassword.text ?? "")
        
        let secureKeyForServerAccess = "sdfsdfsd38792F423F4528482B4D6250655368566D597133743677397A24432646294A40kjsdhfkjsdhf"
        let dataToSend: [String: Any] = [
            "secureKeyForServerAccess_Enabled": secureKeyForServerAccess,
            "actionRequest": "CHECK_USER_LOGIN",
            "email": loginFormEmail.text ?? "",
            "password": encryptedPassword
        ]
        
        accountOperationsObj.sendRequest(toServer: dataToSend) { [weak self] error, success, customErrorMessage in
            guard let self = self else { return }
            
            if success {
                if let message = customErrorMessage, message.hasPrefix("Offline Mode:") {
                    sender.setTitle("Demo Mode", for: .normal)
                    sender.backgroundColor = .orange
                    self.accountOperationsObj.showOfflineNotification(self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else if customErrorMessage == "Login Successful" {
                    sender.setTitle("Logged In", for: .normal)
                    sender.backgroundColor = .green
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.generalAlerts("Alert!", withMessage: customErrorMessage ?? "", withYesActionTitle: "Cancel Log In!", withNoActionTitle: "Back to Login!")
                }
            } else {
                self.generalAlerts("Not Logged In!", withMessage: "Something went wrong please try again!", withYesActionTitle: "Cancel Log In", withNoActionTitle: "Ok!")
                sender.setTitle("Try Again", for: .normal)
            }
        }
    }
    
    @IBAction func loginFormSignInButton(_ sender: UIButton) {
        if loginFormEmail.hasText && loginFormPassword.hasText {
            if accountOperationsObj.validateEmailAccount(loginFormEmail.text ?? "") {
                loginAction(sender)
            } else {
                generalAlerts("Invalid Email!", withMessage: "Please Insert a valid email address", withYesActionTitle: "Cancel Log In", withNoActionTitle: "Ok!")
            }
        } else {
            generalAlerts("Empty Form!", withMessage: "Give your Email and Password", withYesActionTitle: "Cancel Log In", withNoActionTitle: "Ok!")
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
