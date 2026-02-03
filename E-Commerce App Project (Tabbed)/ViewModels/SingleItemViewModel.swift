//
//  SingleItemViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for SingleItemViewController
//

import Foundation

class SingleItemViewModel {
    
    let itemName: Observable<String> = Observable("")
    let itemCategory: Observable<String> = Observable("")
    let itemID: Observable<String> = Observable("")
    let itemPrice: Observable<String> = Observable("$0")
    let itemBrand: Observable<String> = Observable("")
    let itemQuality: Observable<String> = Observable("")
    let itemPhotoURL: Observable<String> = Observable("")
    let isInCart: Observable<Bool> = Observable(false)
    
    private var item: Item?
    private let shoppingCart = ShoppingCart.sharedInstance
    
    func configure(with item: Item) {
        self.item = item
        itemName.value = item.itemName
        itemCategory.value = item.itemCategory
        itemID.value = item.ID?.stringValue ?? ""
        itemPrice.value = "$\(NSNumber(value: item.price))"
        itemBrand.value = item.brand
        itemQuality.value = item.quality
        itemPhotoURL.value = item.photoURL
        refreshCartStatus()
    }
    
    func refreshCartStatus() {
        guard let item = item else { return }
        isInCart.value = shoppingCart.containsItem(item)
    }
    
    func addToCart() {
        guard let item = item else { return }
        shoppingCart.addItem(item)
        isInCart.value = true
    }
    
    func removeFromCart() {
        guard let item = item else { return }
        shoppingCart.removeItem(item)
        refreshCartStatus()
    }
    
    func getItem() -> Item? {
        return item
    }
}
