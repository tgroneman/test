//
//  CategoryItemList.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import Foundation

@objc class CategoryItemList: NSObject {
    @objc static let sharedInstance = CategoryItemList()
    
    @objc private(set) var tvCategoryItemsList: [Item] = []
    @objc private(set) var laptopCategoryItemsList: [Item] = []
    @objc private(set) var mobileCategoryItemsList: [Item] = []
    @objc private(set) var desktopCategoryItemsList: [Item] = []
    @objc private(set) var tabletCategoryItemsList: [Item] = []
    
    private override init() {
        super.init()
        let allItemsList = Items.sharedInstance.allItems
        
        tvCategoryItemsList = returnCategoryArray(allItems: allItemsList, forCategory: "Television")
        laptopCategoryItemsList = returnCategoryArray(allItems: allItemsList, forCategory: "Laptops")
        desktopCategoryItemsList = returnCategoryArray(allItems: allItemsList, forCategory: "Desktop")
        mobileCategoryItemsList = returnCategoryArray(allItems: allItemsList, forCategory: "Mobile")
        tabletCategoryItemsList = returnCategoryArray(allItems: allItemsList, forCategory: "Tablet")
    }
    
    private func returnCategoryArray(allItems: [Item], forCategory itemCategoryName: String) -> [Item] {
        return allItems.filter { $0.itemCategory == itemCategoryName }
    }
}
