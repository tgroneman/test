//
//  AccountLoginViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for AccountLoginViewController
//

import UIKit

enum LoginState {
    case idle
    case loading
    case success
    case offlineMode
    case error(String)
}

class AccountLoginViewModel {
    
    let loginState: Observable<LoginState> = Observable(.idle)
    let email: Observable<String> = Observable("")
    let password: Observable<String> = Observable("")
    
    private let accountOperations = AccountOperations()
    
    func validateEmail(_ email: String) -> Bool {
        return accountOperations.validateEmailAccount(email)
    }
    
    func login(completion: @escaping (Bool, String?) -> Void) {
        guard !email.value.isEmpty, !password.value.isEmpty else {
            loginState.value = .error("Empty Form")
            completion(false, "Give your Email and Password")
            return
        }
        
        guard validateEmail(email.value) else {
            loginState.value = .error("Invalid Email")
            completion(false, "Please Insert a valid email address")
            return
        }
        
        loginState.value = .loading
        
        accountOperations.loginUser(email: email.value, password: password.value) { [weak self] error, success, customErrorMessage in
            guard let self = self else { return }
            
            if success {
                if let message = customErrorMessage, message.hasPrefix("Offline Mode:") {
                    self.loginState.value = .offlineMode
                    completion(true, "Offline Mode")
                } else if customErrorMessage == "Login Successful" {
                    self.loginState.value = .success
                    completion(true, nil)
                } else {
                    self.loginState.value = .error(customErrorMessage ?? "Unknown error")
                    completion(false, customErrorMessage)
                }
            } else {
                self.loginState.value = .error("Login failed")
                completion(false, "Something went wrong please try again!")
            }
        }
    }
    
    func showOfflineNotification(on viewController: UIViewController) {
        accountOperations.showOfflineNotification(viewController)
    }
}
