//
//  Items.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import Foundation

@objc class Items: NSObject {
    @objc static let sharedInstance = Items()
    
    @objc private(set) var allItems: [Item] = []
    
    private override init() {
        super.init()
        allItems = loadItemsFromJSON()
    }
    
    private func loadItemsFromJSON() -> [Item] {
        guard let filePath = Bundle.main.path(forResource: "data", ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
              let jsonArray = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
            return []
        }
        
        var itemArray: [Item] = []
        
        for itemDictionary in jsonArray {
            let itemObject = Item()
            
            if let id = itemDictionary["id"] as? NSNumber {
                itemObject.ID = id
            }
            if let sale = itemDictionary["Sale"] as? NSNumber {
                itemObject.sale = sale
            }
            if let productName = itemDictionary["ProductName"] as? String {
                itemObject.itemName = productName
            }
            if let url = itemDictionary["URL"] as? String {
                itemObject.photoURL = url
            }
            if let price = itemDictionary["Price"] as? Double {
                itemObject.price = price
            } else if let priceNumber = itemDictionary["Price"] as? NSNumber {
                itemObject.price = priceNumber.doubleValue
            }
            if let productType = itemDictionary["ProductType"] as? String {
                itemObject.itemCategory = productType
            }
            if let brandName = itemDictionary["BrandName"] as? String {
                itemObject.brand = brandName
            }
            if let quality = itemDictionary["Quality"] as? String {
                itemObject.quality = quality
            }
            itemObject.cartAddedQuantity = 0
            
            itemArray.append(itemObject)
        }
        
        return itemArray
    }
}
