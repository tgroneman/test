//
//  CategoryItemsViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for CategoryItemsViewController
//

import Foundation

class CategoryItemsViewModel {
    
    let categoryName: Observable<String> = Observable("")
    let items: Observable<[Item]> = Observable([])
    
    func configure(with items: [Item], categoryName: String) {
        self.items.value = items
        self.categoryName.value = categoryName
    }
    
    func numberOfItems() -> Int {
        return items.value.count
    }
    
    func item(at index: Int) -> Item {
        return items.value[index]
    }
    
    func formatPrice(_ price: Double) -> String {
        return "$\(price)"
    }
}
