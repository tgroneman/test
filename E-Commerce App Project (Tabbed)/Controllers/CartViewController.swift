//
//  CartViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemImage: UIImageView!
    var itemName: UILabel!
    var itemPrice: UILabel!
    var itemQuantity: UILabel!
    var itemQuantityInText: String = ""
    var quantityStepper: UIStepper!
    
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet var totalAmountLabelOutlet: UILabel!
    @IBOutlet var totalAmountShowOutlet: UILabel!
    @IBOutlet var editCartButtonOutlet: UIBarButtonItem!
    @IBOutlet var cartContinueButtonOutlet: UIBarButtonItem!
    
    var checkoutCart: ShoppingCart!
    
    private var updatedSingleItemPrice: Double = 0
    private var updatedSingleItemPriceDoubleValueToNumber: NSNumber?
    private var stepperClickedValue: Double = 0
    private var editClicked: Bool = false
    private var intendedPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutCart = ShoppingCart.sharedInstance
        cartTableView.reloadData()
        
        if checkoutCart.itemsInCart().count <= 0 {
            editCartButtonOutlet.isEnabled = false
            editCartButtonOutlet.tintColor = .clear
            cartContinueButtonOutlet.isEnabled = false
            cartContinueButtonOutlet.tintColor = .clear
            totalAmountLabelOutlet.isHidden = true
            totalAmountShowOutlet.isHidden = true
        } else {
            editCartButtonOutlet.isEnabled = true
            editCartButtonOutlet.tintColor = UIColor(named: "Cornflower Blue")
            cartContinueButtonOutlet.isEnabled = true
            cartContinueButtonOutlet.tintColor = UIColor(named: "Cornflower Blue")
            totalAmountLabelOutlet.isHidden = false
            totalAmountShowOutlet.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cartTableView.reloadData()
        
        if checkoutCart.itemsInCart().count <= 0 {
            editCartButtonOutlet.isEnabled = false
            editCartButtonOutlet.tintColor = .clear
            cartContinueButtonOutlet.isEnabled = false
            cartContinueButtonOutlet.tintColor = .clear
            totalAmountLabelOutlet.isHidden = true
            totalAmountShowOutlet.isHidden = true
        } else {
            editCartButtonOutlet.isEnabled = true
            editCartButtonOutlet.tintColor = UIColor(named: "Cornflower Blue")
            cartContinueButtonOutlet.isEnabled = true
            cartContinueButtonOutlet.tintColor = UIColor(named: "Cornflower Blue")
            totalAmountLabelOutlet.isHidden = false
            totalAmountShowOutlet.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let itemObject = checkoutCart.itemsInCart()[indexPath.row]
            intendedPath = indexPath
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCellIdentifier")!
            
            itemImage = cell.viewWithTag(701) as? UIImageView
            itemName = cell.viewWithTag(702) as? UILabel
            itemPrice = cell.viewWithTag(703) as? UILabel
            itemQuantity = cell.viewWithTag(704) as? UILabel
            quantityStepper = cell.viewWithTag(705) as? UIStepper
            
            if let url = URL(string: itemObject.photoURL),
               let data = try? Data(contentsOf: url) {
                itemImage.image = UIImage(data: data)
            }
            itemName.text = itemObject.itemName
            quantityStepper.value = itemObject.cartAddedQuantity
            
            updatedSingleItemPrice = itemObject.cartAddedQuantity * itemObject.price
            updatedSingleItemPriceDoubleValueToNumber = NSNumber(value: updatedSingleItemPrice)
            itemPrice.text = showPrice(updatedSingleItemPriceDoubleValueToNumber)
            
            itemQuantityInText = NSNumber(value: itemObject.cartAddedQuantity).stringValue
            itemQuantity.text = itemQuantityInText
            totalAmountShowOutlet.text = showPrice(checkoutCart.total())
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? checkoutCart.itemsInCart().count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        let stepperValue = sender.value
        let buttonPosition = sender.convert(CGPoint.zero, to: cartTableView)
        if let rowIndexPath = cartTableView.indexPathForRow(at: buttonPosition) {
            returnStepperValue(rowIndexPath, withStepperValue: stepperValue)
        }
    }
    
    func returnStepperValue(_ indexPath: IndexPath, withStepperValue stepperValue: Double) {
        let itemObject = checkoutCart.itemsInCart()[indexPath.row]
        itemObject.cartAddedQuantity = stepperValue
        cartTableView.reloadData()
    }
    
    @IBAction func editCartButton(_ sender: Any) {
        if !editClicked {
            cartTableView.setEditing(true, animated: true)
            editClicked = true
            cartTableView.reloadData()
        } else {
            cartTableView.setEditing(false, animated: true)
            editClicked = false
            cartTableView.reloadData()
        }
    }
    
    @IBAction func CartContinueButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "SeesionUserLoggedIN") {
            performSegue(withIdentifier: "cartToLogInSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "checkOutSegue", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemObject = checkoutCart.itemsInCart()[indexPath.row]
            checkoutCart.removeFromCart(itemObject)
            totalAmountShowOutlet.text = checkoutCart.total().stringValue
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func showPrice(_ price: NSNumber?) -> String {
        guard let price = price else { return "$0" }
        return "$\(price)"
    }
}
