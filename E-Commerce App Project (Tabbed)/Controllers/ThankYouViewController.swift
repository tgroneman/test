//
//  ThankYouViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit
import WebKit

class ThankYouViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel = ThankYouViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet var wkwebviewOutletForPDFShow: WKWebView!
    @IBOutlet var uiviewForArko: UIView!
    @IBOutlet var emailThankYouPage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.userEmail.bind { [weak self] email in
            self?.emailThankYouPage.text = email
        }
        
        viewModel.pdfFilePath.bind { [weak self] path in
            guard let self = self, let pdfUrl = self.viewModel.getPDFURL() else { return }
            self.wkwebviewOutletForPDFShow.loadFileURL(pdfUrl, allowingReadAccessTo: pdfUrl)
        }
    }
}
