//
//  CheckOutViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit
import MessageUI

class CheckOutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - ViewModel
    private let viewModel = CheckOutViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet var checkOutTotalAmount: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var country: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var State: UILabel!
    @IBOutlet var postalCode: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var bkashOutlet: UIButton!
    @IBOutlet var rocketOutlet: UIButton!
    @IBOutlet var cashOnDeliveryOutlet: UIButton!
    
    private var PDFFilePath: String = ""
    private var paymentAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPaymentAlert()
        bindViewModel()
        viewModel.loadUserData()
    }
    
    private func setupPaymentAlert() {
        paymentAlert = UIAlertController(
            title: "Payment Method Not Selected",
            message: "Please Choose your payment method From the Payment Method Section",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "OK!", style: .default, handler: nil)
        paymentAlert.addAction(yesAction)
    }
    
    private func bindViewModel() {
        viewModel.isUserLoggedIn.bind { [weak self] isLoggedIn in
            guard let self = self else { return }
            self.bkashOutlet.isHidden = !isLoggedIn
            self.rocketOutlet.isHidden = !isLoggedIn
            self.cashOnDeliveryOutlet.isHidden = !isLoggedIn
        }
        
        viewModel.totalAmount.bind { [weak self] total in
            self?.checkOutTotalAmount.text = total
        }
        
        viewModel.firstName.bind { [weak self] value in
            self?.firstName.text = value
        }
        
        viewModel.lastName.bind { [weak self] value in
            self?.lastName.text = value
        }
        
        viewModel.email.bind { [weak self] value in
            self?.email.text = value
        }
        
        viewModel.phone.bind { [weak self] value in
            self?.phone.text = value
        }
        
        viewModel.country.bind { [weak self] value in
            self?.country.text = value
        }
        
        viewModel.state.bind { [weak self] value in
            self?.State.text = value
        }
        
        viewModel.city.bind { [weak self] value in
            self?.city.text = value
        }
        
        viewModel.postalCode.bind { [weak self] value in
            self?.postalCode.text = value
        }
        
        viewModel.address.bind { [weak self] value in
            self?.address.text = value
        }
        
        viewModel.selectedPaymentMethod.bind { [weak self] method in
            guard let self = self else { return }
            self.updatePaymentMethodUI(method)
        }
    }
    
    private func updatePaymentMethodUI(_ method: PaymentMethod) {
        let checkedImage = UIImage(named: "checkboxChecked-icon-40.png")
        let uncheckedImage = UIImage(named: "checkboxUnchecked-icon-40.png")
        
        switch method {
        case .none:
            bkashOutlet.setImage(uncheckedImage, for: .normal)
            rocketOutlet.setImage(uncheckedImage, for: .normal)
            cashOnDeliveryOutlet.setImage(uncheckedImage, for: .normal)
        case .bkash:
            bkashOutlet.setImage(checkedImage, for: .normal)
            rocketOutlet.setImage(uncheckedImage, for: .normal)
            cashOnDeliveryOutlet.setImage(uncheckedImage, for: .normal)
        case .rocket:
            bkashOutlet.setImage(uncheckedImage, for: .normal)
            rocketOutlet.setImage(checkedImage, for: .normal)
            cashOnDeliveryOutlet.setImage(uncheckedImage, for: .normal)
        case .cashOnDelivery:
            bkashOutlet.setImage(uncheckedImage, for: .normal)
            rocketOutlet.setImage(uncheckedImage, for: .normal)
            cashOnDeliveryOutlet.setImage(checkedImage, for: .normal)
        }
    }
    
    @IBAction func bkashAction(_ sender: Any) {
        if viewModel.selectedPaymentMethod.value == .bkash {
            viewModel.selectPaymentMethod(.none)
        } else {
            viewModel.selectPaymentMethod(.bkash)
        }
    }
    
    @IBAction func rocketAction(_ sender: Any) {
        if viewModel.selectedPaymentMethod.value == .rocket {
            viewModel.selectPaymentMethod(.none)
        } else {
            viewModel.selectPaymentMethod(.rocket)
        }
    }
    
    @IBAction func cashOnDeliveryAction(_ sender: Any) {
        if viewModel.selectedPaymentMethod.value == .cashOnDelivery {
            viewModel.selectPaymentMethod(.none)
        } else {
            viewModel.selectPaymentMethod(.cashOnDelivery)
        }
    }
    
    @IBAction func finishCheckOutButton(_ sender: Any) {
        guard viewModel.isPaymentMethodSelected() else {
            present(paymentAlert, animated: true, completion: nil)
            return
        }
        
        PDFFilePath = viewModel.savePDF()
        sendMailWithPDF()
        viewModel.completeCheckout()
        performSegue(withIdentifier: "checkoutToThankyouSegue", sender: nil)
    }
    
    func sendMailWithPDF() {
        if MFMailComposeViewController.canSendMail() {
            let saleMail = MFMailComposeViewController()
            saleMail.mailComposeDelegate = self
            saleMail.setSubject("Invoice From ICTcom App")
            saleMail.setMessageBody("Thanks so much for your purchase.<br>Please find the attached invoice.<br>Thanks From ICTcom", isHTML: true)
            
            if let contentsOfFile = try? Data(contentsOf: URL(fileURLWithPath: PDFFilePath)) {
                saleMail.addAttachmentData(contentsOfFile, mimeType: "application/pdf", fileName: "Invoice")
            }
            
            if let userEmail = viewModel.getUserEmail() {
                saleMail.setToRecipients([userEmail])
            }
            
            present(saleMail, animated: true, completion: nil)
        } else {
            print("Device can't send email! maybe Simulator")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
