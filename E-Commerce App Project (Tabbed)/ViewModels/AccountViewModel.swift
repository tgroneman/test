//
//  AccountViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for AccountViewController
//

import Foundation

class AccountViewModel {
    
    let isLoggedIn: Observable<Bool> = Observable(false)
    let userFirstName: Observable<String> = Observable("")
    let userLastName: Observable<String> = Observable("")
    let userEmail: Observable<String> = Observable("")
    let userPhone: Observable<String> = Observable("")
    let userCountry: Observable<String> = Observable("")
    let userState: Observable<String> = Observable("")
    let userCity: Observable<String> = Observable("")
    let userPostalCode: Observable<String> = Observable("")
    let userAddress: Observable<String> = Observable("")
    
    private let defaults = UserDefaults.standard
    
    init() {
        refreshUserData()
    }
    
    func refreshUserData() {
        isLoggedIn.value = defaults.bool(forKey: "SeesionUserLoggedIN")
        
        if isLoggedIn.value {
            if let userData = defaults.dictionary(forKey: "LoggedInUsersDetail") {
                userFirstName.value = userData["firstName"] as? String ?? ""
                userLastName.value = userData["lastName"] as? String ?? ""
                userEmail.value = userData["usersEmail"] as? String ?? ""
                userPhone.value = userData["phone"] as? String ?? ""
                userCountry.value = userData["country"] as? String ?? ""
                userState.value = userData["state"] as? String ?? ""
                userCity.value = userData["city"] as? String ?? ""
                userPostalCode.value = userData["postalCode"] as? String ?? ""
                userAddress.value = userData["address"] as? String ?? ""
            }
        } else {
            clearUserData()
        }
    }
    
    private func clearUserData() {
        userFirstName.value = ""
        userLastName.value = ""
        userEmail.value = ""
        userPhone.value = ""
        userCountry.value = ""
        userState.value = ""
        userCity.value = ""
        userPostalCode.value = ""
        userAddress.value = ""
    }
    
    func logout() {
        defaults.set(false, forKey: "SeesionUserLoggedIN")
        defaults.removeObject(forKey: "LoggedInUsersDetail")
        defaults.removeObject(forKey: "SessionLoggedInuserEmail")
        defaults.synchronize()
        
        isLoggedIn.value = false
        clearUserData()
    }
}
