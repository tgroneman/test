//
//  SingleItemViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import UIKit

class SingleItemViewController: ViewController {
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemCategory: UILabel!
    @IBOutlet var itemID: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var itemBrand: UILabel!
    @IBOutlet var itemQuality: UILabel!
    @IBOutlet var addToCartStatusoutlet: UIButton!
    @IBOutlet var removeFromCartOutlet: UIButton!
    
    var setItemImage: Data?
    var setItemName: String?
    var setItemCategory: String?
    var setItemID: NSNumber?
    var setItemPrice: NSNumber?
    var setItemBrand: String?
    var setItemQuality: String?
    
    var itemAlreadyAddedAlert: UIAlertController!
    var itemObjectReceived: Item?
    var theItemObject: Item?
    
    private var checkoutCart: ShoppingCart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutCart = ShoppingCart.sharedInstance
        theItemObject = itemObjectReceived
        
        addToCartStatusoutlet.isSelected = checkoutCart.containsItem(theItemObject!)
        
        if let imageData = setItemImage {
            itemImage.image = UIImage(data: imageData)
        }
        itemName.text = setItemName
        itemCategory.text = setItemCategory
        itemID.text = setItemID?.stringValue
        itemPrice.text = showPrice(setItemPrice)
        itemBrand.text = setItemBrand
        itemQuality.text = setItemQuality
        
        itemAlreadyAddedAlert = UIAlertController(
            title: "Already Added To The Cart",
            message: "Item Will Be Added To Your Cart Again",
            preferredStyle: .alert
        )
        
        let yesButton = UIAlertAction(title: "Got it!", style: .default, handler: nil)
        
        let noButton = UIAlertAction(title: "Add To Cart Again!", style: .default) { [weak self] _ in
            guard let self = self, let item = self.theItemObject else { return }
            let cart = ShoppingCart.sharedInstance
            cart.addItem(item)
            self.addToCartStatusoutlet.isSelected = true
        }
        
        itemAlreadyAddedAlert.addAction(yesButton)
        itemAlreadyAddedAlert.addAction(noButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let item = theItemObject {
            addToCartStatusoutlet.isSelected = checkoutCart.containsItem(item)
        }
        removeFromCartOutlet.isHidden = !addToCartStatusoutlet.isSelected
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !addToCartStatusoutlet.isSelected {
            removeFromCartOutlet.isHidden = true
            addToCartStatusoutlet.setTitle("Add To Cart", for: .normal)
        } else {
            removeFromCartOutlet.isHidden = false
            addToCartStatusoutlet.setTitle("Add To Cart Again", for: .normal)
        }
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        guard let item = theItemObject else { return }
        
        if !addToCartStatusoutlet.isSelected {
            checkoutCart.addItem(item)
            addToCartStatusoutlet.isSelected = true
            removeFromCartOutlet.isHidden = false
            sender.setTitle("Again Add To Cart", for: .normal)
            sender.backgroundColor = .green
            sender.setTitleColor(.black, for: .normal)
        } else {
            removeFromCartOutlet.isHidden = false
            present(itemAlreadyAddedAlert, animated: true, completion: nil)
            sender.setTitle("Again Add To Cart", for: .normal)
            sender.backgroundColor = .green
            sender.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBAction func removeFromCartButton(_ sender: UIButton) {
        guard let item = theItemObject else { return }
        checkoutCart.removeItem(item)
        addToCartStatusoutlet.isSelected = false
        sender.setTitle("Add To Cart", for: .normal)
        sender.setImage(UIImage(named: "addToCart-icon-40.png"), for: .normal)
        sender.backgroundColor = .blue
    }
    
    func showPrice(_ price: NSNumber?) -> String {
        guard let price = price else { return "$0" }
        return "$\(price)"
    }
}
