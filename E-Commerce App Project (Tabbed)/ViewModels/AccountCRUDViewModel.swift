//
//  AccountCRUDViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for AccountCRUDViewController
//

import UIKit

enum RegistrationState {
    case idle
    case loading
    case success
    case error(String)
}

class AccountCRUDViewModel {
    
    let registrationState: Observable<RegistrationState> = Observable(.idle)
    let editState: Observable<RegistrationState> = Observable(.idle)
    
    let firstName: Observable<String> = Observable("")
    let lastName: Observable<String> = Observable("")
    let email: Observable<String> = Observable("")
    let password: Observable<String> = Observable("")
    let confirmPassword: Observable<String> = Observable("")
    let phone: Observable<String> = Observable("")
    let country: Observable<String> = Observable("")
    let state: Observable<String> = Observable("")
    let city: Observable<String> = Observable("")
    let postalCode: Observable<String> = Observable("")
    let address: Observable<String> = Observable("")
    
    let isLoggedIn: Observable<Bool> = Observable(false)
    
    private let accountOperations = AccountOperations.sharedInstance
    private let defaults = UserDefaults.standard
    private var existingUserEmail: String = ""
    
    init() {
        loadExistingUserData()
    }
    
    func loadExistingUserData() {
        isLoggedIn.value = defaults.bool(forKey: "SeesionUserLoggedIN")
        
        if isLoggedIn.value {
            if let userData = defaults.dictionary(forKey: "LoggedInUsersDetail") {
                firstName.value = userData["firstName"] as? String ?? ""
                lastName.value = userData["lastName"] as? String ?? ""
                existingUserEmail = userData["usersEmail"] as? String ?? ""
                email.value = existingUserEmail
                phone.value = userData["phone"] as? String ?? ""
                country.value = userData["country"] as? String ?? ""
                state.value = userData["state"] as? String ?? ""
                city.value = userData["city"] as? String ?? ""
                postalCode.value = userData["postalCode"] as? String ?? ""
                address.value = userData["address"] as? String ?? ""
            }
        }
    }
    
    func validateEmail(_ email: String) -> Bool {
        return accountOperations.validateEmailAccount(email)
    }
    
    func validateRegistrationForm() -> (Bool, String?) {
        if firstName.value.isEmpty || lastName.value.isEmpty || email.value.isEmpty ||
           password.value.isEmpty || confirmPassword.value.isEmpty || phone.value.isEmpty ||
           country.value.isEmpty || state.value.isEmpty || city.value.isEmpty ||
           postalCode.value.isEmpty || address.value.isEmpty {
            return (false, "Please complete the form!")
        }
        
        if !validateEmail(email.value) {
            return (false, "Please Insert a valid email address")
        }
        
        if password.value != confirmPassword.value {
            return (false, "Confirm password and password Must be same")
        }
        
        return (true, nil)
    }
    
    func register(completion: @escaping (Bool, String?) -> Void) {
        let (isValid, errorMessage) = validateRegistrationForm()
        guard isValid else {
            registrationState.value = .error(errorMessage ?? "Validation failed")
            completion(false, errorMessage)
            return
        }
        
        registrationState.value = .loading
        
        let encryptedPassword = accountOperations.sha1(password.value)
        let encryptedConfirmPassword = accountOperations.sha1(confirmPassword.value)
        
        let dataToSend: [String: Any] = [
            "actionRequest": "REGISTER_USER",
            "firstName": firstName.value,
            "lastName": lastName.value,
            "email": email.value,
            "password": encryptedPassword,
            "confirmPassword": encryptedConfirmPassword,
            "phone": phone.value,
            "country": country.value,
            "state": state.value,
            "city": city.value,
            "postalCode": postalCode.value,
            "address": address.value
        ]
        
        accountOperations.sendRequest(toServer: dataToSend) { [weak self] (error: Error?, success: Bool, customErrorMessage: String?) in
            guard let self = self else { return }
            
            if success && customErrorMessage == "Registraition Successful" {
                self.registrationState.value = .success
                completion(true, nil)
            } else {
                self.registrationState.value = .error(customErrorMessage ?? "Registration failed")
                completion(false, customErrorMessage)
            }
        }
    }
    
    func updateAccount(completion: @escaping (Bool, String?) -> Void) {
        let (isValid, errorMessage) = validateRegistrationForm()
        guard isValid else {
            editState.value = .error(errorMessage ?? "Validation failed")
            completion(false, errorMessage)
            return
        }
        
        editState.value = .loading
        
        let encryptedPassword = accountOperations.sha1(password.value)
        let encryptedConfirmPassword = accountOperations.sha1(confirmPassword.value)
        
        let dataToSend: [String: Any] = [
            "actionRequest": "EDIT_USER",
            "firstName": firstName.value,
            "lastName": lastName.value,
            "email": existingUserEmail,
            "password": encryptedPassword,
            "confirmPassword": encryptedConfirmPassword,
            "phone": phone.value,
            "country": country.value,
            "state": state.value,
            "city": city.value,
            "postalCode": postalCode.value,
            "address": address.value
        ]
        
        accountOperations.sendRequest(toServer: dataToSend) { [weak self] (error: Error?, success: Bool, customErrorMessage: String?) in
            guard let self = self else { return }
            
            if success && customErrorMessage == "Update Successful" {
                self.editState.value = .success
                completion(true, nil)
            } else {
                self.editState.value = .error(customErrorMessage ?? "Update failed")
                completion(false, customErrorMessage)
            }
        }
    }
}
