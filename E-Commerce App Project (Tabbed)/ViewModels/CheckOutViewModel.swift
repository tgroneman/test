//
//  CheckOutViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for CheckOutViewController
//

import Foundation

enum PaymentMethod: String {
    case none = ""
    case bkash = "Bkash"
    case rocket = "Rocket"
    case cashOnDelivery = "Cash On Delivery"
}

class CheckOutViewModel {
    
    let totalAmount: Observable<String> = Observable("")
    let firstName: Observable<String> = Observable("")
    let lastName: Observable<String> = Observable("")
    let email: Observable<String> = Observable("")
    let phone: Observable<String> = Observable("")
    let country: Observable<String> = Observable("")
    let state: Observable<String> = Observable("")
    let city: Observable<String> = Observable("")
    let postalCode: Observable<String> = Observable("")
    let address: Observable<String> = Observable("")
    
    let selectedPaymentMethod: Observable<PaymentMethod> = Observable(.none)
    let isUserLoggedIn: Observable<Bool> = Observable(false)
    
    private let shoppingCart = ShoppingCart.sharedInstance
    private let defaults = UserDefaults.standard
    private var userData: [String: Any]?
    
    init() {
        loadUserData()
    }
    
    func loadUserData() {
        isUserLoggedIn.value = defaults.bool(forKey: "SeesionUserLoggedIN")
        
        if isUserLoggedIn.value {
            userData = defaults.dictionary(forKey: "LoggedInUsersDetail")
            
            totalAmount.value = "$\(defaults.value(forKey: "cartTotalAmount") ?? "")"
            firstName.value = userData?["firstName"] as? String ?? ""
            lastName.value = userData?["lastName"] as? String ?? ""
            email.value = userData?["usersEmail"] as? String ?? ""
            phone.value = userData?["phone"] as? String ?? ""
            country.value = userData?["country"] as? String ?? ""
            state.value = userData?["state"] as? String ?? ""
            city.value = userData?["city"] as? String ?? ""
            postalCode.value = userData?["postalCode"] as? String ?? ""
            address.value = userData?["address"] as? String ?? ""
        }
    }
    
    func selectPaymentMethod(_ method: PaymentMethod) {
        if selectedPaymentMethod.value == method {
            selectedPaymentMethod.value = .none
            defaults.set("", forKey: "paymentMethodUsed")
        } else {
            selectedPaymentMethod.value = method
            defaults.set(method.rawValue, forKey: "paymentMethodUsed")
        }
        defaults.synchronize()
    }
    
    func isPaymentMethodSelected() -> Bool {
        return selectedPaymentMethod.value != .none
    }
    
    func getHTMLString() -> String {
        let pdfLogoUrl = "https://apiforios.appendtech.com/logo.png"
        
        guard let filePath = Bundle.main.path(forResource: "invoice", ofType: "html"),
              let singleItemFilePath = Bundle.main.path(forResource: "single_item", ofType: "html"),
              var strHTML = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            return ""
        }
        
        let itemsInCartArray = shoppingCart.itemsInCart()
        
        var allItemsHTMLArray: [String] = []
        for item in itemsInCartArray {
            if var srtItemHTML = try? String(contentsOfFile: singleItemFilePath, encoding: .utf8) {
                srtItemHTML = srtItemHTML.replacingOccurrences(of: "#productName", with: item.itemName)
                srtItemHTML = srtItemHTML.replacingOccurrences(of: "#quantity", with: NSNumber(value: item.cartAddedQuantity).stringValue)
                srtItemHTML = srtItemHTML.replacingOccurrences(of: "#price", with: NSNumber(value: item.price).stringValue)
                allItemsHTMLArray.append(srtItemHTML)
            }
        }
        let allItemsHTMLString = allItemsHTMLArray.joined(separator: "\n")
        
        strHTML = strHTML.replacingOccurrences(of: "#ITEMS#", with: allItemsHTMLString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: Date())
        
        let ownerInfo = "ICTcom<br>An E-commerce App Project<br>Developed BY: Rony Banik (Arko)<br>"
        strHTML = strHTML.replacingOccurrences(of: "#ownerInfo", with: ownerInfo)
        strHTML = strHTML.replacingOccurrences(of: "#appIcon", with: pdfLogoUrl)
        strHTML = strHTML.replacingOccurrences(of: "#invoiceDate", with: dateString)
        strHTML = strHTML.replacingOccurrences(of: "#cartTotal", with: defaults.value(forKey: "cartTotalAmount") as? String ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#firstName", with: firstName.value)
        strHTML = strHTML.replacingOccurrences(of: "#lastName", with: lastName.value)
        strHTML = strHTML.replacingOccurrences(of: "#email", with: email.value)
        strHTML = strHTML.replacingOccurrences(of: "#phone", with: phone.value)
        strHTML = strHTML.replacingOccurrences(of: "#country", with: country.value)
        strHTML = strHTML.replacingOccurrences(of: "#city", with: city.value)
        strHTML = strHTML.replacingOccurrences(of: "#state", with: state.value)
        strHTML = strHTML.replacingOccurrences(of: "#postalCode", with: postalCode.value)
        strHTML = strHTML.replacingOccurrences(of: "#address", with: address.value)
        strHTML = strHTML.replacingOccurrences(of: "#paymentMethod", with: selectedPaymentMethod.value.rawValue)
        
        return strHTML
    }
    
    func savePDF() -> String {
        let pageFrame = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        
        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        let printFormatter = UIMarkupTextPrintFormatter(markupText: getHTMLString())
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        UIGraphicsBeginPDFPage()
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()
        
        var pdfFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        pdfFilePath = pdfFilePath + "/invoiceFromICTcom.pdf"
        pdfData.write(toFile: pdfFilePath, atomically: true)
        
        defaults.set(pdfFilePath, forKey: "pdfFilePath")
        defaults.synchronize()
        
        return pdfFilePath
    }
    
    func completeCheckout() {
        defaults.set("", forKey: "cartTotalAmount")
        defaults.set("", forKey: "paymentMethodUsed")
        defaults.synchronize()
        shoppingCart.clearCart()
    }
    
    func getUserEmail() -> String? {
        return userData?["usersEmail"] as? String
    }
}
