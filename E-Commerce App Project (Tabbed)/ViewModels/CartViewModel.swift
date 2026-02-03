//
//  CartViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for CartViewController
//

import Foundation

class CartViewModel {
    
    let cartItems: Observable<[Item]> = Observable([])
    let totalAmount: Observable<String> = Observable("$0")
    let isCartEmpty: Observable<Bool> = Observable(true)
    let isUserLoggedIn: Observable<Bool> = Observable(false)
    
    private let shoppingCart = ShoppingCart.sharedInstance
    private let defaults = UserDefaults.standard
    
    init() {
        refreshCart()
    }
    
    func refreshCart() {
        cartItems.value = shoppingCart.itemsInCart()
        isCartEmpty.value = cartItems.value.isEmpty
        updateTotal()
        checkLoginStatus()
    }
    
    private func updateTotal() {
        let total = shoppingCart.total()
        totalAmount.value = "$\(total)"
    }
    
    private func checkLoginStatus() {
        isUserLoggedIn.value = defaults.bool(forKey: "SeesionUserLoggedIN")
    }
    
    func numberOfItems() -> Int {
        return cartItems.value.count
    }
    
    func item(at index: Int) -> Item {
        return cartItems.value[index]
    }
    
    func updateQuantity(at index: Int, quantity: Double) {
        let item = cartItems.value[index]
        item.cartAddedQuantity = quantity
        updateTotal()
    }
    
    func removeItem(at index: Int) {
        let item = cartItems.value[index]
        shoppingCart.removeFromCart(item)
        refreshCart()
    }
    
    func itemPrice(at index: Int) -> String {
        let item = cartItems.value[index]
        let totalPrice = item.cartAddedQuantity * item.price
        return "$\(NSNumber(value: totalPrice))"
    }
    
    func itemQuantity(at index: Int) -> Double {
        return cartItems.value[index].cartAddedQuantity
    }
    
    func shouldNavigateToCheckout() -> Bool {
        return isUserLoggedIn.value
    }
}
