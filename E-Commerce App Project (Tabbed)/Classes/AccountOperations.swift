//
//  AccountOperations.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import Foundation
import UIKit
import CommonCrypto

@objc class AccountOperations: NSObject {
    @objc static let sharedInstance = AccountOperations()
    
    @objc var isOfflineMode: Bool = false
    
    private var itemArray: [Any] = []
    private var urlSession: URLSession?
    
    private override init() {
        super.init()
        isOfflineMode = false
    }
    
    @objc func getDummyUserData() -> [String: String] {
        return [
            "firstName": "Demo",
            "lastName": "User",
            "usersEmail": "demo@example.com",
            "phone": "555-123-4567",
            "address": "123 Demo Street, Sample City",
            "userExist": "TRUE",
            "RequestExecuted": "TRUE",
            "actionRequest": "CHECK_USER_LOGIN"
        ]
    }
    
    @objc func showOfflineNotification(_ viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Offline Mode",
            message: "Unable to connect to server. The app is running in offline mode with demo data.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func handleOfflineMode(withAction actionRequest: String?, callback: @escaping (Error?, Bool, String?) -> Void) {
        isOfflineMode = true
        let defaults = UserDefaults.standard
        
        if actionRequest == "CHECK_USER_LOGIN" {
            let dummyData = getDummyUserData()
            defaults.set(true, forKey: "SeesionUserLoggedIN")
            defaults.set(dummyData["usersEmail"], forKey: "SessionLoggedInuserEmail")
            defaults.set(dummyData, forKey: "LoggedInUsersDetail")
            defaults.synchronize()
            callback(nil, true, "Offline Mode: Logged in with demo account")
        } else if actionRequest == "REGISTER_USER" {
            callback(nil, true, "Offline Mode: Registration simulated successfully")
        } else if actionRequest == "EDIT_USER" {
            callback(nil, true, "Offline Mode: Profile update simulated successfully")
        } else {
            callback(nil, true, "Offline Mode: Operation completed with demo data")
        }
    }
    
    @objc func sha1(_ str: String) -> String {
        let data = Data(str.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    @objc func getURLSession() -> URLSession {
        if urlSession == nil {
            let configuration = URLSessionConfiguration.default
            urlSession = URLSession(configuration: configuration)
        }
        return urlSession!
    }
    
    @objc func sendRequest(toServer dataToSend: [String: Any], callback: @escaping (Error?, Bool, String?) -> Void) {
        let actionRequest = dataToSend["actionRequest"] as? String
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend, options: []) else {
            handleOfflineMode(withAction: actionRequest, callback: callback)
            return
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8),
              let url = URL(string: "https://apiforios.appendtech.com/urltosendrequestwithdata.php?InitialSecureKey:ououhkju59703373367639792F423F4528482B4D6251655468576D5A7134743777217A25iuiu") else {
            handleOfflineMode(withAction: actionRequest, callback: callback)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("theHeaderString", forHTTPHeaderField: "AmrLagto")
        
        let requestData = jsonString.data(using: .utf8)!
        request.setValue("\(requestData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = requestData
        
        let task = getURLSession().dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if error != nil {
                    self.handleOfflineMode(withAction: actionRequest, callback: callback)
                    return
                }
                
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
                    self.handleOfflineMode(withAction: actionRequest, callback: callback)
                    return
                }
                
                let defaults = UserDefaults.standard
                
                if httpResponse.statusCode == 200 && (responseDictionary["RequestExecuted"] as? String) == "TRUE" {
                    let responseAction = responseDictionary["actionRequest"] as? String
                    
                    if responseAction == "REGISTER_USER" {
                        if (responseDictionary["NullFieldsFound"] as? String) == "TRUE" {
                            callback(nil, true, "Every Form Field is required for Successful purchase")
                        } else if (responseDictionary["userRegistrationPassMisMatch"] as? String) == "YES" {
                            callback(nil, true, "Password and Confirm Password must be same!")
                        } else if (responseDictionary["userAlreadyRegistered"] as? String) == "YES" {
                            callback(nil, true, "This email is already registered")
                        } else {
                            callback(nil, true, "Registraition Successful")
                        }
                    } else if responseAction == "CHECK_USER_LOGIN" {
                        if (responseDictionary["userExist"] as? String) == "TRUE" {
                            defaults.set(true, forKey: "SeesionUserLoggedIN")
                            defaults.set(responseDictionary["usersEmail"], forKey: "SessionLoggedInuserEmail")
                            defaults.set(responseDictionary, forKey: "LoggedInUsersDetail")
                            defaults.synchronize()
                            callback(nil, true, "Login Successful")
                        } else if (responseDictionary["passwordMismatch"] as? String) == "YES" {
                            defaults.set(false, forKey: "SeesionUserLoggedIN")
                            defaults.set("", forKey: "SessionLoggedInuserEmail")
                            defaults.synchronize()
                            callback(nil, true, "Wrong Password!")
                        } else {
                            defaults.set(false, forKey: "SeesionUserLoggedIN")
                            defaults.set("", forKey: "SessionLoggedInuserEmail")
                            defaults.synchronize()
                            callback(nil, true, "User Does Not Exist!")
                        }
                    } else if responseAction == "EDIT_USER" {
                        if (responseDictionary["NullFieldsFound"] as? String) == "TRUE" {
                            callback(nil, true, "Every Field is Required!")
                        } else if (responseDictionary["userUpdatePassMisMatch"] as? String) == "YES" {
                            callback(nil, true, "Password and Confirm Password must be same!")
                        } else {
                            callback(nil, true, "Update Successful")
                        }
                    } else {
                        callback(nil, true, "Check Your Request!")
                    }
                } else {
                    self.handleOfflineMode(withAction: actionRequest, callback: callback)
                }
            }
        }
        task.resume()
    }
    
    @objc func validateEmailAccount(_ checkString: String) -> Bool {
        let stricterFilter = false
        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: checkString)
    }
}
