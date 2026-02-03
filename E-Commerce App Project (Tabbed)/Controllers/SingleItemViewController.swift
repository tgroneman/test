//
//  SingleItemViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit

class SingleItemViewController: ViewController {
    
    // MARK: - ViewModel
    private let viewModel = SingleItemViewModel()
    
    // MARK: - IBOutlets
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemObjectReceived {
            viewModel.configure(with: item)
        }
        
        setupUI()
        setupAlert()
        bindViewModel()
    }
    
    private func setupUI() {
        if let imageData = setItemImage {
            itemImage.image = UIImage(data: imageData)
        }
        itemName.text = setItemName
        itemCategory.text = setItemCategory
        itemID.text = setItemID?.stringValue
        itemPrice.text = "$\(setItemPrice ?? 0)"
        itemBrand.text = setItemBrand
        itemQuality.text = setItemQuality
    }
    
    private func setupAlert() {
        itemAlreadyAddedAlert = UIAlertController(
            title: "Already Added To The Cart",
            message: "Item Will Be Added To Your Cart Again",
            preferredStyle: .alert
        )
        
        let dismissAction = UIAlertAction(title: "Got it!", style: .default, handler: nil)
        
        let addAgainAction = UIAlertAction(title: "Add To Cart Again!", style: .default) { [weak self] _ in
            self?.viewModel.addToCart()
        }
        
        itemAlreadyAddedAlert.addAction(dismissAction)
        itemAlreadyAddedAlert.addAction(addAgainAction)
    }
    
    private func bindViewModel() {
        viewModel.isInCart.bind { [weak self] isInCart in
            guard let self = self else { return }
            self.addToCartStatusoutlet.isSelected = isInCart
            self.removeFromCartOutlet.isHidden = !isInCart
            self.addToCartStatusoutlet.setTitle(isInCart ? "Add To Cart Again" : "Add To Cart", for: .normal)
            if isInCart {
                self.addToCartStatusoutlet.backgroundColor = .green
                self.addToCartStatusoutlet.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshCartStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refreshCartStatus()
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        if !viewModel.isInCart.value {
            viewModel.addToCart()
        } else {
            present(itemAlreadyAddedAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func removeFromCartButton(_ sender: UIButton) {
        viewModel.removeFromCart()
        sender.setTitle("Add To Cart", for: .normal)
        sender.setImage(UIImage(named: "addToCart-icon-40.png"), for: .normal)
        sender.backgroundColor = .blue
    }
}
