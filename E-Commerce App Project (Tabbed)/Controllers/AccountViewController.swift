//
//  AccountViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit

class AccountViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel = AccountViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet var firstName: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var country: UILabel!
    @IBOutlet var state: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var postalCode: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var goToLoginButtonOutlet: UIButton!
    
    @IBOutlet var firstNameOutlet: UILabel!
    @IBOutlet var lastNameOutlet: UILabel!
    @IBOutlet var emailOutlet: UILabel!
    @IBOutlet var phoneOutlet: UILabel!
    @IBOutlet var countryOutlet: UILabel!
    @IBOutlet var stateOutlet: UILabel!
    @IBOutlet var cityOutlet: UILabel!
    @IBOutlet var postalCodeOutlet: UILabel!
    @IBOutlet var addressOutlet: UILabel!
    @IBOutlet var userHistoryOutlet: UIBarButtonItem!
    @IBOutlet var userLogOutOutlet: UIBarButtonItem!
    @IBOutlet var editUserAccountOutlet: UIBarButtonItem!
    
    var loggedOutAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogoutAlert()
        bindViewModel()
        viewModel.refreshUserData()
    }
    
    private func setupLogoutAlert() {
        loggedOutAlert = UIAlertController(
            title: "Log Out?",
            message: "Are you sure?",
            preferredStyle: .alert
        )
        
        let logoutAction = UIAlertAction(title: "Yes, Log Out!", style: .default) { [weak self] _ in
            self?.viewModel.logout()
        }
        
        let cancelAction = UIAlertAction(title: "Log Back In!", style: .default, handler: nil)
        
        loggedOutAlert.addAction(cancelAction)
        loggedOutAlert.addAction(logoutAction)
    }
    
    private func bindViewModel() {
        viewModel.isLoggedIn.bind { [weak self] isLoggedIn in
            guard let self = self else { return }
            if isLoggedIn {
                self.showUserInfo()
            } else {
                self.hideUserInfo()
            }
        }
        
        viewModel.userFirstName.bind { [weak self] value in
            self?.firstName.text = value
        }
        
        viewModel.userLastName.bind { [weak self] value in
            self?.lastName.text = value
        }
        
        viewModel.userEmail.bind { [weak self] value in
            self?.email.text = value
        }
        
        viewModel.userPhone.bind { [weak self] value in
            self?.phone.text = value
        }
        
        viewModel.userCountry.bind { [weak self] value in
            self?.country.text = value
        }
        
        viewModel.userState.bind { [weak self] value in
            self?.state.text = value
        }
        
        viewModel.userCity.bind { [weak self] value in
            self?.city.text = value
        }
        
        viewModel.userPostalCode.bind { [weak self] value in
            self?.postalCode.text = value
        }
        
        viewModel.userAddress.bind { [weak self] value in
            self?.address.text = value
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.reloadInputViews()
        viewModel.refreshUserData()
    }
    
    private func hideUserInfo() {
        firstName.isHidden = true
        lastName.isHidden = true
        email.isHidden = true
        phone.isHidden = true
        country.isHidden = true
        state.isHidden = true
        city.isHidden = true
        postalCode.isHidden = true
        address.isHidden = true
        firstNameOutlet.isHidden = true
        lastNameOutlet.isHidden = true
        emailOutlet.isHidden = true
        phoneOutlet.isHidden = true
        countryOutlet.isHidden = true
        stateOutlet.isHidden = true
        cityOutlet.isHidden = true
        postalCodeOutlet.isHidden = true
        addressOutlet.isHidden = true
        goToLoginButtonOutlet.isHidden = false
        userHistoryOutlet.isEnabled = false
        userHistoryOutlet.tintColor = .clear
        userLogOutOutlet.isEnabled = false
        userLogOutOutlet.tintColor = .clear
    }
    
    private func showUserInfo() {
        firstName.isHidden = false
        lastName.isHidden = false
        email.isHidden = false
        phone.isHidden = false
        country.isHidden = false
        state.isHidden = false
        city.isHidden = false
        postalCode.isHidden = false
        address.isHidden = false
        firstNameOutlet.isHidden = false
        lastNameOutlet.isHidden = false
        emailOutlet.isHidden = false
        phoneOutlet.isHidden = false
        countryOutlet.isHidden = false
        stateOutlet.isHidden = false
        cityOutlet.isHidden = false
        postalCodeOutlet.isHidden = false
        addressOutlet.isHidden = false
        goToLoginButtonOutlet.isHidden = true
        userHistoryOutlet.isEnabled = false
        userHistoryOutlet.tintColor = .clear
        userLogOutOutlet.isEnabled = true
        userLogOutOutlet.tintColor = UIColor(named: "Cornflower Blue")
    }
    
    @IBAction func theEditButtonForLoginOrEdit(_ sender: Any) {
        if viewModel.isLoggedIn.value {
            performSegue(withIdentifier: "editAccountSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "loginAccountSegue", sender: nil)
        }
    }
    
    @IBAction func goToLoginButton(_ sender: Any) {
        performSegue(withIdentifier: "loginAccountSegue", sender: nil)
    }
    
    @IBAction func userLogoutButton(_ sender: Any) {
        present(loggedOutAlert, animated: true, completion: nil)
    }
}
