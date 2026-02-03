//
//  Item.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import Foundation

@objc class Item: NSObject {
    @objc var itemName: String = ""
    @objc var photoURL: String = ""
    @objc var quality: String = ""
    @objc var itemCategory: String = ""
    @objc var brand: String = ""
    @objc var price: Double = 0.0
    @objc var sale: NSNumber?
    @objc var ID: NSNumber?
    @objc var cartAddedQuantity: Double = 0.0
}
