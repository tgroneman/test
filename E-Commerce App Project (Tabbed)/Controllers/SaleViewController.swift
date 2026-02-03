//
//  SaleViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import UIKit

class SaleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var saleCollectionView: UICollectionView!
    var saleItemsList: [Item] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let allItemsList = Items.sharedInstance.allItems
        saleItemsList = returnSaleArray(allItemsList)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let allItemsList = Items.sharedInstance.allItems
        saleItemsList = returnSaleArray(allItemsList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saleCollectionView.dataSource = self
        saleCollectionView.delegate = self
    }
    
    func returnSaleArray(_ allItems: [Item]) -> [Item] {
        return allItems.filter { item in
            if let sale = item.sale {
                return sale.intValue != 0
            }
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allItemsList = Items.sharedInstance.allItems
        saleItemsList = returnSaleArray(allItemsList)
        let individualData = saleItemsList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sellCellIdentifier", for: indexPath)
        
        if let itemImage = cell.viewWithTag(601) as? UIImageView,
           let itemName = cell.viewWithTag(602) as? UILabel,
           let itemPrice = cell.viewWithTag(603) as? UILabel {
            if let url = URL(string: individualData.photoURL),
               let data = try? Data(contentsOf: url) {
                itemImage.image = UIImage(data: data)
            }
            itemName.text = individualData.itemName
            itemPrice.text = showPrice(individualData.price)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allItemsList = Items.sharedInstance.allItems
        saleItemsList = returnSaleArray(allItemsList)
        return saleItemsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleItemView = storyboard?.instantiateViewController(withIdentifier: "singleItemViewStoryBoardIdentifier") as? SingleItemViewController else { return }
        
        let individualData = saleItemsList[indexPath.row]
        
        singleItemView.itemObjectReceived = individualData
        
        if let url = URL(string: individualData.photoURL),
           let data = try? Data(contentsOf: url) {
            singleItemView.setItemImage = data
        }
        singleItemView.setItemName = individualData.itemName
        singleItemView.setItemCategory = individualData.itemCategory
        singleItemView.setItemID = individualData.ID
        singleItemView.setItemPrice = NSNumber(value: individualData.price)
        singleItemView.setItemBrand = individualData.brand
        singleItemView.setItemQuality = individualData.quality
        
        navigationController?.pushViewController(singleItemView, animated: true)
    }
    
    func showPrice(_ price: Double) -> String {
        return "$\(price)"
    }
}
