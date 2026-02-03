//
//  CartViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - ViewModel
    private let viewModel = CartViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet var totalAmountLabelOutlet: UILabel!
    @IBOutlet var totalAmountShowOutlet: UILabel!
    @IBOutlet var editCartButtonOutlet: UIBarButtonItem!
    @IBOutlet var cartContinueButtonOutlet: UIBarButtonItem!
    
    private var editClicked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.refreshCart()
    }
    
    private func bindViewModel() {
        viewModel.isCartEmpty.bind { [weak self] isEmpty in
            guard let self = self else { return }
            self.updateUIForCartState(isEmpty: isEmpty)
        }
        
        viewModel.totalAmount.bind { [weak self] total in
            self?.totalAmountShowOutlet.text = total
        }
    }
    
    private func updateUIForCartState(isEmpty: Bool) {
        editCartButtonOutlet.isEnabled = !isEmpty
        editCartButtonOutlet.tintColor = isEmpty ? .clear : UIColor(named: "Cornflower Blue")
        cartContinueButtonOutlet.isEnabled = !isEmpty
        cartContinueButtonOutlet.tintColor = isEmpty ? .clear : UIColor(named: "Cornflower Blue")
        totalAmountLabelOutlet.isHidden = isEmpty
        totalAmountShowOutlet.isHidden = isEmpty
        cartTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refreshCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshCart()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let itemObject = viewModel.item(at: indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCellIdentifier")!
            
            let itemImage = cell.viewWithTag(701) as? UIImageView
            let itemName = cell.viewWithTag(702) as? UILabel
            let itemPrice = cell.viewWithTag(703) as? UILabel
            let itemQuantity = cell.viewWithTag(704) as? UILabel
            let quantityStepper = cell.viewWithTag(705) as? UIStepper
            
            if let url = URL(string: itemObject.photoURL),
               let data = try? Data(contentsOf: url) {
                itemImage?.image = UIImage(data: data)
            }
            itemName?.text = itemObject.itemName
            quantityStepper?.value = viewModel.itemQuantity(at: indexPath.row)
            itemPrice?.text = viewModel.itemPrice(at: indexPath.row)
            itemQuantity?.text = "\(Int(viewModel.itemQuantity(at: indexPath.row)))"
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.numberOfItems() : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        let stepperValue = sender.value
        let buttonPosition = sender.convert(CGPoint.zero, to: cartTableView)
        if let rowIndexPath = cartTableView.indexPathForRow(at: buttonPosition) {
            viewModel.updateQuantity(at: rowIndexPath.row, quantity: stepperValue)
            cartTableView.reloadData()
        }
    }
    
    @IBAction func editCartButton(_ sender: Any) {
        editClicked = !editClicked
        cartTableView.setEditing(editClicked, animated: true)
        cartTableView.reloadData()
    }
    
    @IBAction func CartContinueButton(_ sender: Any) {
        if viewModel.shouldNavigateToCheckout() {
            performSegue(withIdentifier: "checkOutSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "cartToLogInSegue", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
