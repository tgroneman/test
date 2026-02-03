//
//  AccountCRUDViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit

class AccountCRUDViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel = AccountCRUDViewModel()
    
    // MARK: - IBOutlets (Registration)
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var country: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var postalCode: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var validationStatus: UILabel!
    
    // MARK: - IBOutlets (Edit Account)
    @IBOutlet var editAccountFirstName: UITextField!
    @IBOutlet var editAccountLastName: UITextField!
    @IBOutlet var editAccountEmail: UITextField!
    @IBOutlet var editAccountPassword: UITextField!
    @IBOutlet var editAccountConfirmPassword: UITextField!
    @IBOutlet var editAccountPhone: UITextField!
    @IBOutlet var editAccountCountry: UITextField!
    @IBOutlet var editAccountState: UITextField!
    @IBOutlet var editAccountCity: UITextField!
    @IBOutlet var editAccountPostalCode: UITextField!
    @IBOutlet var editAccountAddress: UITextField!
    @IBOutlet var editAccountValidationStatus: UILabel!
    
    var registrationComplete: UIAlertController!
    private var validatorObj: Validation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validationStatus.isHidden = true
        validatorObj = Validation()
        
        setupValidators()
        setupRegistrationAlert()
        bindViewModel()
        
        if viewModel.isLoggedIn.value {
            loadExistingUserData()
        }
    }
    
    private func setupValidators() {
        firstName.ajw_attach(validatorObj.requiredMinLengthValidator("First Name is Required!", integerforMinLength: 1, minLengthErrorMessage: "It has to be something at least!", withLabelForValidationRules: validationStatus))
        editAccountFirstName.ajw_attach(validatorObj.requiredMinLengthValidator("First Name is Required!", integerforMinLength: 1, minLengthErrorMessage: "It has to be something at least!", withLabelForValidationRules: validationStatus))
        
        lastName.ajw_attach(validatorObj.requiredMinLengthValidator("Last Name is Required!", integerforMinLength: 1, minLengthErrorMessage: "Last Name Please!", withLabelForValidationRules: validationStatus))
        editAccountLastName.ajw_attach(validatorObj.requiredMinLengthValidator("Last Name is Required!", integerforMinLength: 1, minLengthErrorMessage: "Last Name Please!", withLabelForValidationRules: validationStatus))
        
        phone.ajw_attach(validatorObj.phoneValidator(validationStatus))
        editAccountPhone.ajw_attach(validatorObj.phoneValidator(validationStatus))
        
        email.ajw_attach(validatorObj.emailValidator(validationStatus))
        editAccountEmail.ajw_attach(validatorObj.emailValidator(validationStatus))
        
        password.ajw_attach(validatorObj.requiredMinLengthValidator("Password is required!", integerforMinLength: 6, minLengthErrorMessage: "It must be at least 6 charecters!", withLabelForValidationRules: validationStatus))
        editAccountPassword.ajw_attach(validatorObj.requiredMinLengthValidator("Password is required!", integerforMinLength: 6, minLengthErrorMessage: "It must be at least 6 charecters!", withLabelForValidationRules: validationStatus))
        
        confirmPassword.ajw_attach(validatorObj.requiredValidator("Required and Should be same as 'Password'", withLabelForValidationRules: validationStatus))
        editAccountConfirmPassword.ajw_attach(validatorObj.requiredValidator("Required and Should be same as 'Password'", withLabelForValidationRules: validationStatus))
        
        country.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        state.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        city.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        postalCode.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        address.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        
        editAccountCountry.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountState.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountCity.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountPostalCode.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountAddress.ajw_attach(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
    }
    
    private func setupRegistrationAlert() {
        registrationComplete = UIAlertController(
            title: "Registered!",
            message: "You've Successfully Registered!",
            preferredStyle: .alert
        )
        
        let yesButton = UIAlertAction(title: "Log In!", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        registrationComplete.addAction(yesButton)
    }
    
    private func bindViewModel() {
        viewModel.firstName.bindWithoutFire { [weak self] value in
            self?.editAccountFirstName.text = value
        }
        viewModel.lastName.bindWithoutFire { [weak self] value in
            self?.editAccountLastName.text = value
        }
        viewModel.email.bindWithoutFire { [weak self] value in
            self?.editAccountEmail.text = value
        }
        viewModel.phone.bindWithoutFire { [weak self] value in
            self?.editAccountPhone.text = value
        }
        viewModel.country.bindWithoutFire { [weak self] value in
            self?.editAccountCountry.text = value
        }
        viewModel.state.bindWithoutFire { [weak self] value in
            self?.editAccountState.text = value
        }
        viewModel.city.bindWithoutFire { [weak self] value in
            self?.editAccountCity.text = value
        }
        viewModel.postalCode.bindWithoutFire { [weak self] value in
            self?.editAccountPostalCode.text = value
        }
        viewModel.address.bindWithoutFire { [weak self] value in
            self?.editAccountAddress.text = value
        }
    }
    
    private func loadExistingUserData() {
        viewModel.loadExistingUserData()
        editAccountFirstName.text = viewModel.firstName.value
        editAccountLastName.text = viewModel.lastName.value
        editAccountEmail.text = viewModel.email.value
        editAccountPhone.text = viewModel.phone.value
        editAccountCountry.text = viewModel.country.value
        editAccountState.text = viewModel.state.value
        editAccountCity.text = viewModel.city.value
        editAccountPostalCode.text = viewModel.postalCode.value
        editAccountAddress.text = viewModel.address.value
    }
    
    @IBAction func registerAccount(_ sender: UIButton) {
        guard firstName.hasText && lastName.hasText && email.hasText && password.hasText && confirmPassword.hasText && phone.hasText && country.hasText && state.hasText && city.hasText && postalCode.hasText && address.hasText else {
            generalAlerts("Empty Form", withMessage: "Please complete the form!", withYesActionTitle: "Already Registered!", withNoActionTitle: "Got it!")
            return
        }
        
        guard viewModel.validateEmail(email.text ?? "") else {
            generalAlerts("Invalid Email!", withMessage: "Please Insert a valid email address", withYesActionTitle: "Cancel Registration!", withNoActionTitle: "Ok!")
            return
        }
        
        guard password.text == confirmPassword.text else {
            generalAlerts("Password Mismatch!", withMessage: "Confirm password and password Must be same", withYesActionTitle: "Log In!", withNoActionTitle: "Back To Form!")
            return
        }
        
        viewModel.firstName.value = firstName.text ?? ""
        viewModel.lastName.value = lastName.text ?? ""
        viewModel.email.value = email.text ?? ""
        viewModel.password.value = password.text ?? ""
        viewModel.confirmPassword.value = confirmPassword.text ?? ""
        viewModel.phone.value = phone.text ?? ""
        viewModel.country.value = country.text ?? ""
        viewModel.state.value = state.text ?? ""
        viewModel.city.value = city.text ?? ""
        viewModel.postalCode.value = postalCode.text ?? ""
        viewModel.address.value = address.text ?? ""
        
        viewModel.register { [weak self] success, message in
            guard let self = self else { return }
            if success {
                sender.setTitle("Registered", for: .normal)
                sender.backgroundColor = .blue
                self.present(self.registrationComplete, animated: true, completion: nil)
            } else {
                self.generalAlerts("Alert!", withMessage: message ?? "", withYesActionTitle: "Cancel Registration!", withNoActionTitle: "Fix it!")
                sender.setTitle("Try Again", for: .normal)
            }
        }
    }
    
    @IBAction func editAccount(_ sender: UIButton) {
        guard editAccountFirstName.hasText && editAccountLastName.hasText && editAccountEmail.hasText && editAccountPassword.hasText && editAccountConfirmPassword.hasText && editAccountPhone.hasText && editAccountCountry.hasText && editAccountState.hasText && editAccountCity.hasText && editAccountPostalCode.hasText && editAccountAddress.hasText else {
            generalAlerts("Empty Form", withMessage: "Please complete the form!", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Got it!")
            return
        }
        
        guard viewModel.validateEmail(editAccountEmail.text ?? "") else {
            generalAlerts("Invalid Email!", withMessage: "Please Insert a valid email address", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Ok!")
            return
        }
        
        guard editAccountPassword.text == editAccountConfirmPassword.text else {
            generalAlerts("Password Mismatch!", withMessage: "Confirm password and password Must be same", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Back To Form!")
            return
        }
        
        viewModel.firstName.value = editAccountFirstName.text ?? ""
        viewModel.lastName.value = editAccountLastName.text ?? ""
        viewModel.password.value = editAccountPassword.text ?? ""
        viewModel.confirmPassword.value = editAccountConfirmPassword.text ?? ""
        viewModel.phone.value = editAccountPhone.text ?? ""
        viewModel.country.value = editAccountCountry.text ?? ""
        viewModel.state.value = editAccountState.text ?? ""
        viewModel.city.value = editAccountCity.text ?? ""
        viewModel.postalCode.value = editAccountPostalCode.text ?? ""
        viewModel.address.value = editAccountAddress.text ?? ""
        
        viewModel.updateAccount { [weak self] success, message in
            guard let self = self else { return }
            if success {
                sender.setTitle("Account Updated!", for: .normal)
                sender.backgroundColor = .blue
                self.generalAlerts("Account Updated!", withMessage: "Your Account Have Successfully Updated!", withYesActionTitle: "Log In!", withNoActionTitle: "OK")
            } else {
                self.generalAlerts("Alert!", withMessage: message ?? "", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Fix it!")
                sender.setTitle("Try Again", for: .normal)
                sender.backgroundColor = .red
            }
        }
    }
    
    func generalAlerts(_ alertTitle: String, withMessage alertMessage: String, withYesActionTitle yesActionTitle: String, withNoActionTitle noActionTitle: String) {
        let generalAlert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: yesActionTitle, style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: noActionTitle, style: .default, handler: nil)
        
        generalAlert.addAction(yesAction)
        generalAlert.addAction(noAction)
        present(generalAlert, animated: true, completion: nil)
    }
}
