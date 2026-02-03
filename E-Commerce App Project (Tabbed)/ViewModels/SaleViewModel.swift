//
//  SaleViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for SaleViewController
//

import Foundation

class SaleViewModel {
    
    let saleItems: Observable<[Item]> = Observable([])
    
    init() {
        loadSaleItems()
    }
    
    private func loadSaleItems() {
        let allItems = Items.sharedInstance.allItems
        saleItems.value = allItems.filter { item in
            if let sale = item.sale {
                return sale.intValue != 0
            }
            return false
        }
    }
    
    func numberOfItems() -> Int {
        return saleItems.value.count
    }
    
    func item(at index: Int) -> Item {
        return saleItems.value[index]
    }
    
    func formatPrice(_ price: Double) -> String {
        return "$\(price)"
    }
}
