//
//  ThankYouViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for ThankYouViewController
//

import Foundation

class ThankYouViewModel {
    
    let pdfFilePath: Observable<String> = Observable("")
    let userEmail: Observable<String> = Observable("")
    
    private let defaults = UserDefaults.standard
    
    init() {
        loadData()
    }
    
    func loadData() {
        pdfFilePath.value = defaults.value(forKey: "pdfFilePath") as? String ?? ""
        userEmail.value = defaults.value(forKey: "SessionLoggedInuserEmail") as? String ?? ""
    }
    
    func getPDFURL() -> URL? {
        guard !pdfFilePath.value.isEmpty else { return nil }
        return URL(fileURLWithPath: pdfFilePath.value)
    }
}
